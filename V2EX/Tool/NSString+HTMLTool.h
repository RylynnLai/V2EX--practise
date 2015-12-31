//
//  NSString+HTMLTool.h
//  V2EX
//
//  Created by ucs on 15/12/23.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTMLTool)
/**返回用于展示的文章正文*/
+ (NSString *)HTMLstringWithBody:(NSString *)body;
@end
