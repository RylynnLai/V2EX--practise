//
//  RLTopicsTVC.m
//  V2EX
//
//  Created by ucs on 15/12/22.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "RLTopicsTVC.h"
#import "RLTopicsTool.h"
#import "RLTopicCell.h"
//#import "RLTopicDetailVC.h"
#import "AFNetWorking.h"
#import "NSString+Extension.h"

#define tagW screenW * 0.4
#define tipicesNumOfEachPage 20

@interface RLTopicsTVC ()<UIScrollViewDelegate>
{
    UIButton *_recentBtn;
    UIButton *_popBtn;
    NSInteger _currentPageIdx;//当前加载到的页码,20条话题一页(由服务器决定)
    RLPageSelected _pageSelected;//最新or最热
}
/**保存数据模型数组*/
@property (nonatomic, strong) NSArray *topics;
@end

@implementation RLTopicsTVC

#pragma mark ------------------------------------------------------------
#pragma mark 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    //MJRefresh
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollViewDidScroll:self.tableView];
    //第一次加载出现时显示最近话题页面,只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self tagClick:_recentBtn];
    });
}

#pragma mark ------------------------------------------------------------
#pragma mark action方法
//下拉刷新
- (void)refreshData {
    [[RLTopicsTool shareRLTopicsTool] setCurrentPageIdx:1];
    self.topics = nil;
    [self loadData];
}
//上拉加载更多
- (void)loadMore {
    if (_pageSelected == RLPopTopicsPage) {//在最热话题不需要上拉刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
        return;
    }
    int pageIdx = [[RLTopicsTool shareRLTopicsTool] currentPageIdx];
    [[RLTopicsTool shareRLTopicsTool] setCurrentPageIdx:pageIdx + 1];
    [self loadData];
}

- (void)tagClick:(UIButton *)btn {
    if (btn == _recentBtn) {
        //MJRefresh
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        footer.refreshingTitleHidden = YES;
        self.tableView.mj_footer = footer;
        
        _recentBtn.selected = YES;
        _popBtn.selected = NO;
        _pageSelected = RLRecentTopicsPage;
    }else {
        self.tableView.mj_footer = nil;
        _popBtn.selected = YES;
        _recentBtn.selected = NO;
        _pageSelected = RLPopTopicsPage;
    }
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ------------------------------------------------------------
#pragma mark 私有方法
- (void)initUI {
    _recentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _recentBtn.frame = CGRectMake(0, 0, tagW * 0.5, 30);
    [_recentBtn setTitle:@"最近" forState:UIControlStateNormal];
    [_recentBtn setBackgroundImage:[UIImage imageNamed:@"tagBG"] forState:UIControlStateSelected];
    [_recentBtn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _popBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _popBtn.frame = CGRectMake(tagW * 0.5 - 1, 0, tagW * 0.5, 30);
    [_popBtn setTitle:@"最热" forState:UIControlStateNormal];
    [_popBtn setBackgroundImage:[UIImage imageNamed:@"tagBG"] forState:UIControlStateSelected];
    [_popBtn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tagW, 30)];
    tagView.layer.cornerRadius = 10;
    tagView.layer.masksToBounds = YES;
    tagView.layer.borderWidth = 1;
    tagView.layer.borderColor = V2EXGray.CGColor;
    [tagView setTintColor:V2EXGray];
    [tagView addSubview:_recentBtn];
    [tagView addSubview:_popBtn];
    
    self.navigationItem.titleView = tagView;
    //设置返回按钮
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc]init];
    backBarButtonItem.title =@"";
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    
}

- (void)loadData {
    [[RLTopicsTool shareRLTopicsTool] topicsWithCompletion:^(NSArray *topics) {
        self.topics = topics;
        //在主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
    } option:_pageSelected];
}


#pragma mark ------------------------------------------------------------
#pragma mark 懒加载
- (NSArray *)topics {
    if (!_topics) {
        _topics = [NSArray array];
    }
    return _topics;
}

#pragma mark ------------------------------------------------------------
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"topicCell";
    RLTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = (RLTopicCell *)[RLTopicCell instantiateFromNib];
    }
    if (self.topics.count > 0) {
        cell.topicModel = self.topics[indexPath.row];
    }
    return cell;
}

#pragma mark ------------------------------------------------------------
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.topics.count > 0) {
        if ([[self.topics[indexPath.row] content] length] > 0) {
            return 130;
        }else {
            return 105;
        }
    }
    return 100;
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

#pragma mark ------------------------------------------------------------
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //当前为最顶上控制器才进行下面判断是否隐藏导航条
    if (self.navigationController.topViewController == self) {
        UINavigationBar *navBar = self.navigationController.navigationBar;
        if (scrollView.contentOffset.y > 0 && (navBar.mj_y == 20)) {
            [UIView animateWithDuration:0.5 animations:^{
                navBar.mj_y = - navBar.mj_h;
            }];
        }else if (scrollView.contentOffset.y < 0 && (navBar.mj_y < 0)) {
            [UIView animateWithDuration:0.5 animations:^{
                navBar.mj_y = 20.0;
            }];
        }
    }
}
@end
