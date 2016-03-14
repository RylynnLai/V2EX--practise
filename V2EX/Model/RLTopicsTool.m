//
//  RLTopicsTool.m
//  V2EX
//
//  Created by ucs on 16/1/7.
//  Copyright © 2016年 ucs. All rights reserved.
//

#import "RLTopicsTool.h"
#import "RLTopic.h"
#import "RLTopicReply.h"

@interface RLTopicsTool()

@property (nonatomic, strong) NSMutableArray *topics;
@end

@implementation RLTopicsTool
SingleM(RLTopicsTool)

- (void)topicWithTopicID:(NSString *)ID completion:(void(^)(RLTopic *topic))block; {
    NSString *path = [NSString stringWithFormat:@"/api/topics/show.json?id=%@", ID];
    [[RLNetWorkManager shareRLNetWorkManager] requestWithPath:path success:^(id response) {
        NSArray *topics = [RLTopic mj_objectArrayWithKeyValuesArray:response];
        block([topics firstObject]);
    } failure:^{
    }];
}

- (void)topicsWithCompletion:(void(^)(NSArray *topics))block option:(RLPageSelected)pageSelected{
    if (pageSelected == RLRecentTopicsPage) {
        if (_currentPageIdx == 1) [self.topics removeAllObjects];
        NSString *path = [NSString stringWithFormat:@"/recent?p=%d", _currentPageIdx];
        [[RLNetWorkManager shareRLNetWorkManager] requestHTMLWithPath:path callBackBlock:^(NSArray *resArr) {
            NSArray *tempArr = [RLTopic parserHTMLStrs:resArr];
            for (RLTopic *topic in tempArr) {
                [self.topics addObject:topic];
            }
            block(self.topics);
        }];
    }else if (pageSelected == RLPopTopicsPage) {
        NSString *path = @"/api/topics/hot.json";
        [[RLNetWorkManager shareRLNetWorkManager] requestWithPath:path success:^(id response) {
            self.topics = [RLTopic mj_objectArrayWithKeyValuesArray:response];
            block(self.topics);
        } failure:^{
        }];
    }
}
//https://www.v2ex.com/api/replies/show.json?topic_id=26299

- (void)topicRepliesWithTopicID:(NSString *)ID Completion:(void(^)(NSArray *replies))block {
    NSString *path = [NSString stringWithFormat:@"/api/replies/show.json?topic_id=%@", ID];
    [[RLNetWorkManager shareRLNetWorkManager] requestWithPath:path success:^(id response) {
        NSArray *replies = [RLTopicReply mj_objectArrayWithKeyValuesArray:response];
        block(replies);
    } failure:^{
    }];
}

- (NSMutableArray *)topics {
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}
@end
