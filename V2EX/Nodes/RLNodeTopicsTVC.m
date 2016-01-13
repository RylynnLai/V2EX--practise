//
//  RLNodeTopicsTVC.m
//  V2EX
//
//  Created by rylynn lai on 16/1/10.
//  Copyright © 2016年 ucs. All rights reserved.
//

#import "RLNodeTopicsTVC.h"
#import "RLNode.h"
#import "RLTopic.h"
#import "RLTopicCell.h"
#import "RLNodesHeadView.h"
#import "RLTopicDetailVC.h"

@interface RLNodeTopicsTVC ()

@property (nonatomic, strong) NSMutableArray *topics;
@property (nonatomic, strong) RLNodesHeadView *headView;
@end

@implementation RLNodeTopicsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
  
    //MJRefresh
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [footer setTitle:@"再拉也没用,Livid只给了我10条数据" forState:MJRefreshStateRefreshing];
    self.tableView.mj_footer = footer;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView setTableHeaderView:self.headView];//只能放在这,配合table的头视图代理方法,自适应高度
}

- (void)loadData {
    self.title = _nodeModel.title;
    self.headView.nodeModel = _nodeModel;
    //获取完整的节点数据
    NSString *path = [NSString stringWithFormat:@"/api/nodes/show.json?id=%@", _nodeModel.ID];
    [[RLNetWorkManager shareRLNetWorkManager] requestWithPath:path success:^(id response) {
        _nodeModel = [RLNode mj_objectWithKeyValues:response];
        self.headView.nodeModel = _nodeModel;
    } failure:^{
    }];
}
//下拉刷新
- (void)refreshData {
    if (_nodeModel) {
        [[RLNetWorkManager shareRLNetWorkManager] requestNodeTopicssWithID:_nodeModel.ID success:^(id response) {
            self.topics = [RLTopic mj_objectArrayWithKeyValuesArray:response];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        } failure:^{
        }];
    }
}
//上拉刷新
- (void)loadMore {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
}

#pragma mark ------------------------------------------------------------
#pragma mark 懒加载
- (NSMutableArray *)topics {
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (RLNodesHeadView *)headView {
    if (!_headView) {
        _headView = [RLNodesHeadView nodesHeadView];
    }
    return _headView;
}

#pragma mark ------------------------------------------------------------
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"nodeTopicCell";
    RLTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [RLTopicCell topicCell];
    }
    if (self.topics.count > 0) {
        cell.topicModel = self.topics[indexPath.row];
    }
    return cell;
}

#pragma mark ------------------------------------------------------------
#pragma mark UITableViewDelegate
//神奇地自动计算头视图高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return self.headView.mj_h;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.topics) {
        RLTopicDetailVC *topicDetallVC = [[RLTopicDetailVC alloc] initWithNibName:@"RLTopicDetailVC" bundle:nil];
        topicDetallVC.topicModel =  self.topics[indexPath.row];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:topicDetallVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}


@end
