//
//  RLTopic.m
//  V2EX
//
//  Created by ucs on 15/12/14.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "RLTopic.h"

@implementation RLTopic

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
//解析HTML,获取标题等简单数据
+ (NSMutableDictionary *)parserHTMLStrs:(NSArray *)resArr{
    NSRange range;
    NSString *tempStr;
    NSMutableDictionary *topicDic = [NSMutableDictionary dictionaryWithCapacity:resArr.count];
    
    for (int i = 0; i < resArr.count; i ++) {
        NSString *str = resArr[i];
        RLTopic *topic = [[RLTopic alloc] init];
        
        range = [str rangeOfString:@"#"];
        topic.ID = [str substringToIndex:range.location];
        
        range = [str rangeOfString:@">"];
        topic.title = [str substringFromIndex:range.location];
        
        range = [str rangeOfString:@"reply"];
        tempStr = [str substringFromIndex:range.location];
        range = [tempStr rangeOfString:@"\""];
        topic.replies = [tempStr substringToIndex:range.location];
        [topicDic setObject:topic forKey:[NSString stringWithFormat:@"%d", i]];//保存话题序列
    }
    return topicDic;
}

+ (NSMutableDictionary *)parserResponse:(id)response {
    NSArray *topics = [RLTopic mj_objectArrayWithKeyValuesArray:response];
    NSMutableDictionary *topicDic = [NSMutableDictionary dictionaryWithCapacity:topics.count];
    for (int i = 0; i < topics.count; i ++) {
        [topicDic setObject:topics[i] forKey:[NSString stringWithFormat:@"%d", i]];//保存话题序列
    }
    return topicDic;
}

@end