//
//  RLTopicsTool.h
//  V2EX
//
//  Created by ucs on 16/1/7.
//  Copyright © 2016年 ucs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLTopic.h"

typedef NS_ENUM(int, RLPageSelected) {
    RLRecentTopicsPage,
    RLPopTopicsPage,
};

@interface RLTopicsTool : NSObject
SingleH(RLTopicsTool)

@property (nonatomic) int currentPageIdx;//当前加载到的页码,从1开始,20条话题一页(由服务器决定)

- (void)topicsWithCompletion:(void(^)(NSArray *topics))block option:(RLPageSelected)pageSelected;
//获取话题内容
- (void)topicWithTopicID:(NSString *)ID completion:(void(^)(RLTopic *topic))block;
//获取话题评论
- (void)topicRepliesWithTopicID:(NSString *)ID Completion:(void(^)(NSArray *replies))block;
@end
