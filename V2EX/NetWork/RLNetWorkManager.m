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

//请求话题数据,block返回(以plist文件缓存话题模型)
- (NSURLSessionDataTask *)requestTopicsWithPath:(NSString *)path success:(successBlock)block failure:(errorBlock)errorBlock{
    //截取plist文件名(id=xxxxx)
    NSRange range = [path rangeOfString:@"?"];
    NSString *plistName = @"0000";//初始化
    //存在则表明是单独获取一个话题数据,否则是获取最热话题数组(不缓存)
    if (range.location != NSNotFound) plistName = [path substringFromIndex:range.location + 1];
    //获取沙盒路径
    NSString *cahchesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //plist全路径
    NSString *plistPath = [cahchesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/topics/%@.plist", plistName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:plistPath]) {//存在缓存文件(只有请求单个话题才有可能进去)
        NSArray *responseObject = [NSArray arrayWithContentsOfFile:plistPath];
        block(responseObject);
        return nil;
    }
    //没有缓存
    NSString *URLStr = [mainURL stringByAppendingString:path];
    NSURLSessionDataTask *task = [self.sessionManager GET:URLStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (![plistName isEqualToString:@"0000"]) {
            [responseObject writeToFile:plistPath atomically:YES];//写缓存,如果是获取最新话题列表不用写缓存
        }
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"]
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];//NSData转字典
        RLLog(@"请求话题失败%@", [dic objectForKey:@"message"]);
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
        do {//解析
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
