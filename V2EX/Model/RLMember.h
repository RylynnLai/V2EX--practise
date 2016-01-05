//
//  RLMember.h
//  V2EX
//
//  Created by ucs on 15/12/14.
//  Copyright © 2015年 ucs. All rights reserved.
//

/*"member" : {
 "id" : 69773,
 "username" : "livepps",
 "tagline" : "",
 "avatar_mini" : "//cdn.v2ex.co/gravatar/95555c0bef9012a0eebc76632dfa3061?s=24&d=retro",
 "avatar_normal" : "//cdn.v2ex.co/gravatar/95555c0bef9012a0eebc76632dfa3061?s=48&d=retro",
 "avatar_large" : "//cdn.v2ex.co/gravatar/95555c0bef9012a0eebc76632dfa3061?s=73&d=retro"
 }
 */

#import <Foundation/Foundation.h>

@interface RLMember : NSObject
@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *tagline;

@property (nonatomic, strong) NSString *avatar_mini;

@property (nonatomic, strong) NSString *avatar_normal;

@property (nonatomic, strong) NSString *avatar_large;
@end
