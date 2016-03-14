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
+ (NSMutableArray *)parserHTMLStrs:(NSArray *)resArr{
    NSRange rangeStart;
    NSRange rangEnd;
    NSString *tempStr;
    NSMutableArray *topics = [NSMutableArray arrayWithCapacity:resArr.count];
    
    for (int i = 0; i < resArr.count; i ++) {
        NSString *str = resArr[i];
        RLTopic *topic = [[RLTopic alloc] init];
        
        rangeStart = [str rangeOfString:@"<img src=\""];
        tempStr = [str substringFromIndex:rangeStart.location + rangeStart.length];
        rangEnd = [tempStr rangeOfString:@"\" class=\"avatar\""];
        topic.member.avatar_normal = [tempStr substringToIndex:rangEnd.location];
        
        rangeStart = [tempStr rangeOfString:@"class=\"item_title\"><a href=\"/t/"];
        tempStr = [tempStr substringFromIndex:rangeStart.location + rangeStart.length];
        rangEnd = [tempStr rangeOfString:@"#"];
        topic.ID = [tempStr substringToIndex:rangEnd.location];
        
        rangeStart = [tempStr rangeOfString:@"reply"];
        tempStr = [tempStr substringFromIndex:rangeStart.location + rangeStart.length];
        rangEnd = [tempStr rangeOfString:@"\">"];
        topic.replies = [tempStr substringToIndex:rangEnd.location];
        
        rangeStart = [tempStr rangeOfString:@"\">"];
        tempStr = [tempStr substringFromIndex:rangeStart.location + rangeStart.length];
        rangEnd = [tempStr rangeOfString:@"</a>"];
        topic.title = [tempStr substringToIndex:rangEnd.location];
        
        rangeStart = [tempStr rangeOfString:@"class=\"node\" href=\"/go/"];
        tempStr = [tempStr substringFromIndex:rangeStart.location+ rangeStart.length];
        rangEnd = [tempStr rangeOfString:@"\">"];
        topic.node.name = [tempStr substringToIndex:rangEnd.location];
        
        rangeStart = [tempStr rangeOfString:@"\">"];
        tempStr = [tempStr substringFromIndex:rangeStart.location + rangeStart.length];
        rangEnd = [tempStr rangeOfString:@"</a>"];
        topic.node.title = [tempStr substringToIndex:rangEnd.location];
        
        rangeStart = [tempStr rangeOfString:@"href=\"/member/"];
        tempStr = [tempStr substringFromIndex:rangeStart.location + rangeStart.length];
        rangEnd = [tempStr rangeOfString:@"\">"];
        topic.member.username = [tempStr substringToIndex:rangEnd.location];
        
        rangeStart = [tempStr rangeOfString:@"</strong> &nbsp;•&nbsp;"];
        tempStr = [tempStr substringFromIndex:rangeStart.location + rangeStart.length];
        rangEnd = [tempStr rangeOfString:@"&nbsp;•&nbsp;"];
        if (rangEnd.location == NSNotFound) rangEnd = [tempStr rangeOfString:@"</span>"];
        topic.createdTime = [tempStr substringToIndex:rangEnd.location];
        
        [topics addObject:topic];
    }
    return topics;
}

//+ (NSMutableDictionary *)parserResponse:(id)response {
//    NSArray *topics = [RLTopic mj_objectArrayWithKeyValuesArray:response];
//    NSMutableDictionary *topicDic = [NSMutableDictionary dictionaryWithCapacity:topics.count];
//    for (int i = 0; i < topics.count; i ++) {
//        [topicDic setObject:topics[i] forKey:[NSString stringWithFormat:@"%d", i]];//保存话题序列
//    }
//    return topicDic;
//}

- (instancetype)init {
    if (self = [super init]) {
        RLMember *member = [[RLMember alloc] init];
        RLNode *node = [[RLNode alloc] init];
        self.member = member;
        self.node = node;
    }
    return self;
}

@end
