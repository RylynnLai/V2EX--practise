//
//  RLTopicDetailVC.m
//  V2EX
//
//  Created by ucs on 15/12/22.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "RLTopicDetailVC.h"
#import "NSString+Extension.h"
#import "RLTopicsTool.h"
#import "RLRepliesTV.h"

@interface RLTopicDetailVC ()<UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingAIV;
@property (weak, nonatomic) IBOutlet UILabel *authorLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *createdTimeLable;
@property (weak, nonatomic) IBOutlet UIButton *authorBtn;
@property (weak, nonatomic) IBOutlet UILabel *replieNumLable;
@property (strong, nonatomic) UIWebView *contentWbV;

@end

@implementation RLTopicDetailVC

#pragma mark ------------------------------------------------------------
#pragma mark 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    /*这里规则是
     *检查数据是否完整,完整就直接显示帖子内容,不重新请求;不完整就发起网络请求,并更新内存缓存保存新的数据
     *用户可以手动下拉刷新话题列表刷新或下拉刷新帖子刷新,需要更新缓存数据
     */
    if (_topicModel && _topicModel.content_rendered.length <= 0) {
        [_loadingAIV startAnimating];
        [[RLTopicsTool shareRLTopicsTool] topicWithTopicID:_topicModel.ID completion:^(RLTopic *topic) {
            self.topicModel = topic;
            [self initData];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.1 animations:^{
        self.navigationController.navigationBar.mj_y = 20;
    }];
}

#pragma mark ------------------------------------------------------------
#pragma mark 私有方法
- (void)initUI {
    [self.view addSubview:self.contentWbV];
    _loadingAIV.frame = CGRectMake(self.view.mj_w * 0.5, self.view.mj_h * 0.5, 20, 20);
    _loadingAIV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _loadingAIV.hidesWhenStopped = YES;
}
- (void)initData {
    //导航栏标题
    self.title = _topicModel.title;
    //帖子内容
    NSString *htmlStr = [NSString HTMLstringWithBody:_topicModel.content_rendered];
    [self.contentWbV loadHTMLString:htmlStr baseURL:nil];
    //头像
    NSURL *iconURL = [NSURL URLWithString:[NSString stringWithFormat:@"https:%@", _topicModel.member.avatar_normal]];
    [_authorBtn sd_setImageWithURL:iconURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"blank"]];
    //标题
    _titleLable.text = _topicModel.title;
    _titleLable.adjustsFontSizeToFitWidth = YES;//固定lable大小,内容自适应,还有个固定字体大小,lable自适应的方法sizeToFit
    //作者名称
    _authorLable.text = [NSString stringWithFormat:@"%@ ●", _topicModel.member.username];
    //创建时间
    if (_topicModel.createdTime.length > 0) {
        _createdTimeLable.text = [NSString stringWithFormat:@"%@ ●", _topicModel.createdTime];
    } else {
        _createdTimeLable.text = [NSString creatTimeByTimeIntervalSince1970:[_topicModel.created floatValue]];
    }
    //回复个数
    _replieNumLable.text = [NSString stringWithFormat:@"%d个回复", [_topicModel.replies intValue]];
}

- (void)loadRepliesData {
    NSString *path = [NSString stringWithFormat:@"/api/replies/show.json?topic_id=%@", self.topicModel.ID];
    [[RLNetWorkManager shareRLNetWorkManager] requestWithPath:path success:^(id response) {
        
    } failure:^{
    }];
}

- (void)addRepliesList {
    
}

#pragma mark ------------------------------------------------------------
#pragma mark 懒加载
- (UIWebView *)contentWbV {
    if (!_contentWbV) {
        _contentWbV = [[UIWebView alloc] initWithFrame:CGRectMake(0, _authorLable.mj_h + _authorLable.mj_y, screenW, 10)];
        _contentWbV.delegate = self;
    }
    return _contentWbV;
}

#pragma mark ------------------------------------------------------------
#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_loadingAIV startAnimating];//菊花
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView.isLoading) {
        return;
    }else {
        //更新
        [_loadingAIV stopAnimating];
        webView.mj_h = webView.scrollView.contentSize.height + 64;//加上导航条和状态栏高度
        webView.scrollView.scrollEnabled = NO;
        UIScrollView *scrollView = (UIScrollView *)self.view;
        scrollView.contentSize = CGSizeMake(webView.mj_w, webView.mj_h + 100);//10是预留给回复列表的
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {

}
#pragma mark ------------------------------------------------------------
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

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
