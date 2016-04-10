//
//  RLTabbarVC.m
//  V2EX
//
//  Created by ucs on 15/12/21.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "RLTabbarVC.h"


@interface RLTabbarVC ()

@end

@implementation RLTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:[[RLTopicsTVC alloc] init]];
    nav1.tabBarItem.title = @"V2EX";
    [self addChildViewController:nav1];
    
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:[[RLNodesVC alloc] init]];
    nav2.tabBarItem.title = @"节点";
    [self addChildViewController:nav2];
    
}
//更改统一UI样式
- (void)initUI {
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setTintColor:V2EXGray];
}

@end
