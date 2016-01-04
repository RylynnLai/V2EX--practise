//
//  RLTabbarVC.m
//  V2EX
//
//  Created by ucs on 15/12/21.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "RLTabbarVC.h"
#import "RLTopicsTVC.h"

@interface RLTabbarVC ()

@end

@implementation RLTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:[[RLTopicsTVC alloc] init]];
    nav1.tabBarItem.title = @"话题";
    [self addChildViewController:nav1];
    
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    nav2.tabBarItem.title = @"节点";
    [self addChildViewController:nav2];
    
 }

@end
