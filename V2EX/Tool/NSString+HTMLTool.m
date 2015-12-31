//
//  NSString+HTMLTool.m
//  V2EX
//
//  Created by ucs on 15/12/23.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "NSString+HTMLTool.h"

static NSString *HTNLHead = @"<head><meta charset=\"utf-8\"><meta http-equiv=\"Content-Type\"content=text/html; charset=utf-8\"/><style>img{width:358px !important;}</style></head>";


@implementation NSString (HTMLTool)

+ (NSString *)HTMLstringWithBody:(NSString *)body {
    NSString *htmlStr = [NSString stringWithFormat:@"<html><head><meta charset=\"utf-8\"><meta http-equiv=\"Content-Type\"content=text/html; charset=utf-8\"/><style>img{width:%dpx !important;}</style></head> <body>%@</body></html>", (int)screenW - 17, body];
    return htmlStr;
}

@end