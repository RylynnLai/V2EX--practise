//
//  RLTopicReply.h
//  V2EX
//
//  Created by rylynn lai on 16/3/12.
//  Copyright © 2016年 ucs. All rights reserved.
//
//"id" : 2769021,
//"thanks" : 0,
//"content" : "提了 1.5K ，但我更希望提的是白條，花唄太雞肋，最後還是選信用卡支付。",
//"content_rendered" : "提了 1.5K ，但我更希望提的是白條，花唄太雞肋，最後還是選信用卡支付。",
//"member" : {
//    "id" : 51620,
//    "username" : "Jackiepie",
//    "tagline" : "None",
//    "avatar_mini" : "//cdn.v2ex.co/gravatar/8e31a801f76fb8730d4944a1c6bb348b?s=24&d=retro",
//    "avatar_normal" : "//cdn.v2ex.co/gravatar/8e31a801f76fb8730d4944a1c6bb348b?s=48&d=retro",
//    "avatar_large" : "//cdn.v2ex.co/gravatar/8e31a801f76fb8730d4944a1c6bb348b?s=73&d=retro"
//},
//"created" : 1451371537,
//"last_modified" : 1451371537

#import <Foundation/Foundation.h>
#import "RLMember.h"
@interface RLTopicReply : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *thanks;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *content_rendered;

@property (nonatomic, strong) RLMember *member;

@property (nonatomic, strong) NSString *created;

@property (nonatomic, strong) NSString *last_modified;

@end
