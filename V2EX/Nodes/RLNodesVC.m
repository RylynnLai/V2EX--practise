//
//  RLNodesVC.m
//  V2EX
//
//  Created by ucs on 16/1/5.
//  Copyright © 2016年 ucs. All rights reserved.
//

#import "RLNodesVC.h"
#import "RLBubblesView.h"

@interface RLNodesVC ()
@property (nonatomic, strong) UIScrollView *nodesScrollView;

@end

@implementation RLNodesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    RLBubblesView *BV = [[RLBubblesView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BV.nodeModels = @[@1, @2, @3, @4, @5, @6, @7];
    [self.view addSubview:BV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
