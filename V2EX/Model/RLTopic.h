//
//  RLTopic.h
//  V2EX
//
//  Created by ucs on 15/12/14.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "RLMember.h"
#import "RLNode.h"


@class RLMember, RLNode, RLTopic;

@interface RLTopic : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *content_rendered;

@property (nonatomic, strong) NSString *replies;

@property (nonatomic, strong) RLMember *member;//会员

@property (nonatomic, strong) RLNode *node;//节点

@property (nonatomic, strong) NSString *created;

@property (nonatomic, strong) NSString *createdTime;

@property (nonatomic, strong) NSString *last_modified;

@property (nonatomic, strong) NSString *last_touched;

/**解析HTML文本*/
+ (NSMutableArray *)parserHTMLStrs:(NSArray *)resArr;

@end
