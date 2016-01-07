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

@property (nonatomic) NSInteger currentPageIdx;//当前加载到的页码,从1开始,20条话题一页(由服务器决定)

- (void)topicsWithCompletion:(void(^)(NSArray *topics))block option:(RLPageSelected)pageSelected;
- (void)topicWithTopicID:(NSString *)ID completion:(void(^)(RLTopic *topic))block;
@end
