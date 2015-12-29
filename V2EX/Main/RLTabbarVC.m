//
//  RLTabbarVC.m
//  V2EX
//
//  Created by ucs on 15/12/21.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "RLTabbarVC.h"
#import "RLTopicesTVC.h"

@interface RLTabbarVC ()

@end

@implementation RLTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[RLTopicsTVC alloc] init]];
    [self addChildViewController:nav];
 }

@end
