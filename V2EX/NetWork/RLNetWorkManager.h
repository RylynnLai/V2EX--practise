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

typedef void(^callBackBlock) (NSArray *resArr);
@interface RLNetWorkManager : NSObject

SingleH(RLNetWorkManager)

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path success:(successBlock)block failure:(errorBlock)errorBlock;

/**请求话题数据*/
- (NSURLSessionDataTask *)requestTopicsWithPath:(NSString *)path success:(successBlock)block failure:(errorBlock)errorBlock;
/**请求HTML文本,返回标题字符串*/
- (NSOperation *)requestHTMLWithPath:(NSString *)path callBackBlock:(callBackBlock)black;

/**请求节点数据*/
- (NSURLSessionDataTask *)requestNodesWithPath:(NSString *)path success:(successBlock)block failure:(errorBlock)errorBlock;
@end
