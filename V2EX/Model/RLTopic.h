//
//  RLTopic.h
//  V2EX
//
//  Created by ucs on 15/12/14.
//  Copyright © 2015年 ucs. All rights reserved.
//

/*
 {
 "id" : 243489,
 "title" : "多家银行的密码，大家都怎么记的？",
 "url" : "http://www.v2ex.com/t/243489",
 "content" : "现在每个人应该都有好几家银行的银行卡，信用卡，如果都用同一个密码，应该是很不安全的。\u000D\u000A\u000D\u000A那么取款密码，查询密码，网银密码， U 盾密码，手机银行密码......这么多密码，大家有什么记忆的好建议吗？再算上支付宝，微信之类的支付密码。平时常用的密码基本都记得，就是有些银行卡太久没用就忘了。\u000D\u000A\u000D\u000A感觉这种跟资金有关的密码，放在密码管理软件上不放心，之前考虑过写在 txt 里面 rar 用二十几位字符加密，应该还是很安全的，等哪天忘记密码了可以看看。",
 "content_rendered" : "\u003Cp\u003E现在每个人应该都有好几家银行的银行卡，信用卡，如果都用同一个密码，应该是很不安全的。\u003C/p\u003E\u000A\u000A\u003Cp\u003E那么取款密码，查询密码，网银密码， U 盾密码，手机银行密码......这么多密码，大家有什么记忆的好建议吗？再算上支付宝，微信之类的支付密码。平时常用的密码基本都记得，就是有些银行卡太久没用就忘了。\u003C/p\u003E\u000A\u000A\u003Cp\u003E感觉这种跟资金有关的密码，放在密码管理软件上不放心，之前考虑过写在 txt 里面 rar 用二十几位字符加密，应该还是很安全的，等哪天忘记密码了可以看看。\u003C/p\u003E\u000A",
 "replies" : 3,
 "member" : {
 "id" : 69773,
 "username" : "livepps",
 "tagline" : "",
 "avatar_mini" : "//cdn.v2ex.co/gravatar/95555c0bef9012a0eebc76632dfa3061?s=24&d=retro",
 "avatar_normal" : "//cdn.v2ex.co/gravatar/95555c0bef9012a0eebc76632dfa3061?s=48&d=retro",
 "avatar_large" : "//cdn.v2ex.co/gravatar/95555c0bef9012a0eebc76632dfa3061?s=73&d=retro"
 },
 "node" : {
 "id" : 300,
 "name" : "programmer",
 "title" : "程序员",
 "title_alternative" : "Programmer",
 "url" : "http://www.v2ex.com/go/programmer",
 "topics" : 10349,
 "avatar_mini" : "//cdn.v2ex.co/navatar/94f6/d7e0/300_mini.png?m=1450075560",
 "avatar_normal" : "//cdn.v2ex.co/navatar/94f6/d7e0/300_normal.png?m=1450075560",
 "avatar_large" : "//cdn.v2ex.co/navatar/94f6/d7e0/300_large.png?m=1450075560"
 },
 "created" : 1450086011,
 "last_modified" : 1450086011,
 "last_touched" : 1450086291
 },
 */

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
