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

+ (NSMutableArray *)parserHTMLStrs:(NSArray *)resArr callBack:(callBack)block{
    NSRange range;
    NSString *tempStr;
    NSMutableArray *topices = [NSMutableArray arrayWithCapacity:resArr.count];
    NSMutableDictionary *indexDic = [NSMutableDictionary dictionaryWithCapacity:resArr.count];
    
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
//        [indexDic setValue:[NSNumber numberWithInt:i] forKey:topic.ID];//保存话题序列
        [indexDic setValue:topic forKey:[NSString stringWithFormat:@"%d", i]];//保存话题序列
    }
    block(indexDic);
    return topices;
}


@end
