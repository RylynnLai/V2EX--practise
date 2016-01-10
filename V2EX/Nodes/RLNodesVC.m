//
//  RLNodesVC.m
//  V2EX
//
//  Created by ucs on 16/1/5.
//  Copyright © 2016年 ucs. All rights reserved.
//

#import "RLNodesVC.h"
#import "RLBubblesView.h"
#import "RLNode.h"
#import "RLNodeTopicsTVC.h"
#import "MJExtension.h"

@interface RLNodesVC ()
@property (nonatomic, strong) UIScrollView *nodesScrollView;
@property (nonatomic, weak) RLBubblesView *bubblesView;
@end

@implementation RLNodesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)loadData {
    [[RLNetWorkManager shareRLNetWorkManager] requestWithPath:@"/api/nodes/all.json" success:^(id response) {
        NSArray *AllNodes = [RLNode mj_objectArrayWithKeyValuesArray:response];
        NSMutableArray *nodeModels = [NSMutableArray array];
        for (RLNode *node in AllNodes) {
            if (node.topics.intValue > 100) {
                [nodeModels addObject:node];
            }
        }
        self.bubblesView.nodeModels = nodeModels;
    } failure:^{
    }];
}

#pragma mark ------------------------------------------------------------
#pragma mark 懒加载
- (RLBubblesView *)bubblesView {
    if (!_bubblesView) {
        RLBubblesView *bubblesView = [[RLBubblesView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bubblesView.clickAction = ^(RLNode *nodeModel){
            RLNodeTopicsTVC *nodeTopicsTVC = [[RLNodeTopicsTVC alloc] init];
            nodeTopicsTVC.nodeModel = nodeModel;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nodeTopicsTVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        };
        _bubblesView = bubblesView;
        [self.view addSubview:_bubblesView];
    }
    return _bubblesView;
}

@end
