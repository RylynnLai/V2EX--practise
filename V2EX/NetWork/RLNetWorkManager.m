//
//  RLNetWorkManager.m
//  V2EX
//
//  Created by ucs on 15/12/14.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "RLNetWorkManager.h"
#import "AFNetWorking.h"

static NSString *mainURL = @"https://www.v2ex.com";

@interface RLNetWorkManager ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation RLNetWorkManager

//单例
SingleM(RLNetWorkManager)

//根据url发送网络请求,block返回
- (NSURLSessionDataTask *)requestWithPath:(NSString *)path success:(successBlock)block failure:(errorBlock)errorBlock{
    NSString *URLStr = [mainURL stringByAppendingString:path];
    
    NSURLSessionDataTask *task = [self.sessionManager GET:URLStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        RLLog(@"获取网络数据");
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RLLog(@"%@", error.userInfo);
    }];
    return task;
}

//发送请求获取HTML文本
- (NSOperation *)requestHTMLWithPath:(NSString *)path callBackBlock:(callBackBlock)black{
    NSString *URLStr = [mainURL stringByAppendingString:path];
    NSURL *url = [NSURL URLWithString:URLStr];
    
    NSMutableArray *arr = [NSMutableArray array];
    __block NSString *substring;
    __block NSRange range;
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSData *data = [NSData dataWithContentsOfURL:url];//下载html
        NSString *HTMLStr  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        do {
            range = [HTMLStr rangeOfString:@"\"item_title\"><a href=\"/t/"];//起点
            if (range.location == NSNotFound) break;//跳出
            HTMLStr = [HTMLStr substringFromIndex:NSMaxRange(range)];//截取起点后面的字符串
            range = [HTMLStr rangeOfString:@"</a>"];//终点
            substring = [HTMLStr substringToIndex:range.location];//解析结果
            [arr addObject:substring];
        } while (1);
        black(arr);
    }];
    
    //创建非主队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation]; //[operation start];
    return operation;
}


//懒加载
- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
    }
    return _sessionManager;
}
@end
