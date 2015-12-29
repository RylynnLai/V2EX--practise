//
//  RLNetWorkManager.m
//  V2EX
//
//  Created by ucs on 15/12/14.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "RLNetWorkManager.h"
#import "AFNetWorking.h"

static NSString *mainURL = @"https://www.v2ex.com/api";

@interface RLNetWorkManager ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation RLNetWorkManager

//单例
SingleM(RLNetWorkManager)

//根据url发送网络请求,block返回
- (void)requestWithPath:(NSString *)path success:(successBlock)block failure:(errorBlock)errorBlock{
    NSString *URLStr = [mainURL stringByAppendingString:path];
    [self.sessionManager GET:URLStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        RLLog(@"获取网络数据");
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RLLog(@"%@", error);
    }];
}

//懒加载
- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
    }
    return _sessionManager;
}
@end
