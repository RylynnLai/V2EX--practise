//
//  RLMember.m
//  V2EX
//
//  Created by ucs on 15/12/14.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "RLMember.h"

@implementation RLMember
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
@end
