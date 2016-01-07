//
//  NSString+extension.m
//  V2EX
//
//  Created by ucs on 15/12/29.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "NSString+extension.h"

@implementation NSString (extension)

+ (NSString *)formatStringByTimeIntervalSince1970:(NSTimeInterval)timeInterval {
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];//直接输出的话是机器码
    [formatter setDateFormat:@"yyyy-M-d hh:mm:ss a"];//输出格式
    NSString *str = [formatter stringFromDate:timeDate];
    return str;
}

+ (NSString *)creatTimeByTimeIntervalSince1970:(NSTimeInterval)timeInterval {
    NSDate *creatTimeDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDate *nowTimeDate = [NSDate date];
    NSTimeInterval sec = [nowTimeDate timeIntervalSinceDate:creatTimeDate];

    NSString *timeStr = [[NSString alloc] init];
    if (sec > 0 && sec < 60 * 60) {//1分钟~60分钟
        timeStr = [NSString stringWithFormat:@"约%d分钟前发布 ●", ((int)sec + 30) / 60];
    } else if (sec >= 60 * 60 && sec < 60 * 60 * 24) {//1小时~24小时
        timeStr = [NSString stringWithFormat:@"约%d小时前发布 ●", ((int)(sec / 60) + 30) / 60];
    } else if (sec >= 60 * 60 * 24) {//天
        timeStr = [NSString stringWithFormat:@"约%d天前发布 ●", ((int)((sec / 60) / 60) + 12) / 24];
    }
    return timeStr;
}

@end
