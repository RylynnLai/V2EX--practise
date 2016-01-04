//
//  RLTopicsTVC.m
//  V2EX
//
//  Created by ucs on 15/12/22.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "RLTopicsTVC.h"
#import "RLTopic.h"
#import "RLTopicCell.h"
#import "RLTopicDetailVC.h"
#import "AFNetWorking.h"
#import "NSString+HTMLTool.h"

#define tagW screenW * 0.4
#define tipicesNumOfEachPage 20

@interface RLTopicsTVC ()<UIScrollViewDelegate>
{
    UIButton *_recentBtn;
    UIButton *_popBtn;
    NSInteger _currentPageIdx;
    NSDictionary *_indexDic;
}

@property (nonatomic, strong) NSMutableDictionary *topicDic;
@end

@implementation RLTopicsTVC

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
    //第一次加载出现时刷新和显示最近话题页面,只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.tableView.mj_header beginRefreshing];
        [self tagClick:_recentBtn];
    });
}

//下拉刷新
- (void)refreshData {
    _currentPageIdx = 1;
    [self.topicDic removeAllObjects];
    [self loadData];
}
//加载更多
- (void)loadMore {
    _currentPageIdx ++;
    [self loadData];
}

- (void)loadData {
//    [[RLNetWorkManager shareRLNetWorkManager] requestWithPath:@"/api/topics/hot.json" success:^(id response) {
//        _topics = [RLTopic mj_objectArrayWithKeyValuesArray:response];
//        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
//    } failure:^{
//    }];
    
    __block NSDictionary *tempTopicDic;
    //获取最近的话题HTML文本并解析话题列表
    NSString *path = [NSString stringWithFormat:@"/recent?p=%ld", _currentPageIdx];
    [[RLNetWorkManager shareRLNetWorkManager] requestHTMLWithPath:path callBackBlock:^(NSArray *resArr) {
        if (self.topicDic.count == 0) {
            self.topicDic = [RLTopic parserHTMLStrs:resArr];
        } else {
            tempTopicDic = [RLTopic parserHTMLStrs:resArr];
            for (NSString *idxKey in tempTopicDic) {//这里快速遍历可以获取到key(并不是获到value)
                NSInteger index = idxKey.integerValue + tipicesNumOfEachPage * (_currentPageIdx - 1);
                [self.topicDic setObject:[self.topicDic objectForKey:idxKey] forKey:[NSString stringWithFormat:@"%ld", index]];
            }
        }
        [self.tableView reloadData];
        
        //在主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
        
        for (NSString *idxKey in self.topicDic) {
            RLTopic *topic = [self.topicDic objectForKey:idxKey];
            NSString *path = [NSString stringWithFormat:@"/api/topics/show.json?id=%d", [topic.ID intValue]];
            [[RLNetWorkManager shareRLNetWorkManager] requestWithPath:path success:^(id response) {
                NSArray *topicMs = [RLTopic mj_objectArrayWithKeyValuesArray:response];
                [_topicDic setObject:[topicMs firstObject] forKey:idxKey];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idxKey.intValue inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } failure:^{
            }];
        }
    }];
}


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
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)tagClick:(UIButton *)btn {
    if (btn == _recentBtn) {
        _recentBtn.selected = YES;
        _popBtn.selected = NO;
    }else {
        _popBtn.selected = YES;
        _recentBtn.selected = NO;
    }
}

#pragma mark ------------------------------------------------------------
#pragma mark 懒加载
- (NSMutableDictionary *)topicDic {
    if (!_topicDic) {
        _topicDic = [NSMutableDictionary dictionary];
    }
    return _topicDic;
}

#pragma mark ------------------------------------------------------------
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"topicCell";
    RLTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [RLTopicCell topicCell];
    }
    if (_topicDic) {
        cell.topicModel = [_topicDic objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
    }
    return cell;
}

#pragma mark ------------------------------------------------------------
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RLTopic *topic = [self.topicDic objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
    if ([topic.content_rendered isEqualToString:@""]) {
        return 105;
    }else {
        return 130;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_topicDic) {
        RLTopicDetailVC *topicDetallVC = [[RLTopicDetailVC alloc] initWithNibName:@"RLTopicDetailVC" bundle:nil];
        topicDetallVC.topicModel =  [self.topicDic objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
        
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
        if (scrollView.contentOffset.y >= 0 && (navBar.mj_y == 20)) {
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
