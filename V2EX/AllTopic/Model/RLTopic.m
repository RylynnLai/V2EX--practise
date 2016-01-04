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
    NSMutableArray *topices = [NSMutableArray arrayWithCapacity:resArr.count];
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
        [topices addObject:topic];
        [topicDic setObject:topic forKey:[NSString stringWithFormat:@"%d", i]];//保存话题序列
    }
    return topicDic;
}


@end
