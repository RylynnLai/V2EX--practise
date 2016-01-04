//
//  RLTopicDetailVC.m
//  V2EX
//
//  Created by ucs on 15/12/22.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "RLTopicDetailVC.h"
#import "NSString+HTMLTool.h"
#import "NSString+Extension.h"
#import "RLTopic.h"

@interface RLTopicDetailVC ()<UIWebViewDelegate, UIScrollViewDelegate>
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.mj_y = 20;
}

#pragma mark ------------------------------------------------------------
#pragma mark 私有方法
- (void)initUI {
    [self.view addSubview:self.contentWbV];
}
- (void)initData {
    //文章内容
    NSString *htmlStr = [NSString HTMLstringWithBody:_topicModel.content_rendered];
    [self.contentWbV loadHTMLString:htmlStr baseURL:nil];
    //头像
    NSURL *iconURL = [NSURL URLWithString:[NSString stringWithFormat:@"https:%@", _topicModel.member.avatar_large]];
    [_authorBtn sd_setImageWithURL:iconURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"blank"]];
    //标题
    _titleLable.text = _topicModel.title;
    //作者名称
    _authorLable.text = [NSString stringWithFormat:@"%@ ●", _topicModel.member.username];
    //创建时间
    NSString *TimeStr = [NSString creatTimeByTimeIntervalSince1970:[_topicModel.created intValue]];
    _createdTimeLable.text = [NSString stringWithFormat:@"%@ ●", TimeStr];
    //回复个数
    _replieNumLable.text = [NSString stringWithFormat:@"%d个回复", [_topicModel.replies intValue]];
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

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.mj_h = webView.scrollView.contentSize.height + 64;//加上导航条和状态栏高度
    webView.scrollView.scrollEnabled = NO;
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = CGSizeMake(webView.mj_w, webView.mj_h);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {

}


#pragma mark ------------------------------------------------------------
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    if (scrollView.contentOffset.y >= 0 && (navBar.mj_y == 20)) {
        [UIView animateWithDuration:0.3 animations:^{
            navBar.mj_y = - navBar.mj_h;
        }];
    }else if (scrollView.contentOffset.y < 0 && (navBar.mj_y < 0)) {
        [UIView animateWithDuration:0.3 animations:^{
            navBar.mj_y = 20.0;
        }];
    }
}
@end