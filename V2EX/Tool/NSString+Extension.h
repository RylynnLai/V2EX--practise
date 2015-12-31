//
//  NSString+extension.h
//  V2EX
//
//  Created by ucs on 15/12/29.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (extension)
/**格式化输出时间字符串*/
+ (NSString *)formatStringByTimeIntervalSince1970:(NSTimeInterval)timeInterval;
+ (NSString *)creatTimeByTimeIntervalSince1970:(NSTimeInterval)timeInterval ;
@end
