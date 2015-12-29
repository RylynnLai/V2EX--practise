//
//  RLNetWorkManager.h
//  V2EX
//
//  Created by ucs on 15/12/14.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Single.h"

typedef void(^successBlock) (id response);
typedef void(^errorBlock)();
@interface RLNetWorkManager : NSObject
SingleH(RLNetWorkManager)


- (void)requestWithPath:(NSString *)path success:(successBlock)block failure:(errorBlock)errorBlock;
@end
