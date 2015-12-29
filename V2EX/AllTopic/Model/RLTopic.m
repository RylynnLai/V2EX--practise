//
//  RLTopic.m
//  V2EX
//
//  Created by ucs on 15/12/14.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "RLTopic.h"


@implementation RLTopic

- (void)setMember:(RLMember *)member {
    //替换模型中的属性(注意key-value的对应关系,不要写反)
    [RLMember mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id",
                 };
    }];
    _member = [RLMember mj_objectWithKeyValues:member];
}

- (void)setNode:(RLNode *)node {
    //替换模型中的属性(注意key-value的对应关系,不要写反)
    [RLNode mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id",
                 };
    }];
    _node = [RLNode mj_objectWithKeyValues:node];
}


@end
