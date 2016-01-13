//
//  NSDictionary+Log.m
//  
//
//  Created by 1 on 15/11/6.
//  Copyright © 2015年 RL. All rights reserved.
//  解决中文打印乱码问题,不需要import,拉进工程就行


#import <Foundation/Foundation.h>

@implementation NSDictionary (Log)

-(NSString *)descriptionWithLocale:(id)locale
{
//    return @"小明和小红是好朋友";
    NSMutableString *string = [NSMutableString string];
  
    [string appendString:@"\n{"];
//    [string appendString:@"他们确实是好朋友"];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        [string appendFormat:@"%@:",key];
        [string appendFormat:@"%@,",obj];
    }];
    
    //尝试删除最后一个逗号
    //NSBackwardsSearch 虫后往前搜索
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location !=NSNotFound) {
        [string deleteCharactersInRange:range];
    }
    
    [string appendString:@"}"];
    return string;
}
@end

@implementation NSArray (Log)

-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:@"["];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendFormat:@"%@,",obj];
    }];
    
    //尝试删除最后一个逗号
    //NSBackwardsSearch 虫后往前搜索
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location !=NSNotFound) {
        [string deleteCharactersInRange:range];
    }
    
    [string appendString:@"\n]"];
    return string;
}
@end

