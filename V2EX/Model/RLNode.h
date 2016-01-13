//
//  RLNode.h
//  V2EX
//
//  Created by ucs on 15/12/14.
//  Copyright © 2015年 ucs. All rights reserved.
//

/*"node" : {
 "id" : 300,
 "name" : "programmer",
 "title" : "程序员",
 "title_alternative" : "Programmer",
 "url" : "http://www.v2ex.com/go/programmer",
 "topics" : 10349,
 "avatar_mini" : "//cdn.v2ex.co/navatar/94f6/d7e0/300_mini.png?m=1450075560",
 "avatar_normal" : "//cdn.v2ex.co/navatar/94f6/d7e0/300_normal.png?m=1450075560",
 "avatar_large" : "//cdn.v2ex.co/navatar/94f6/d7e0/300_large.png?m=1450075560"
 }*/

#import <Foundation/Foundation.h>

@interface RLNode : NSObject
@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *name;//用于发请求

@property (nonatomic, strong) NSString *title;//实际显示

@property (nonatomic, strong) NSString *title_alternative;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *topics;

@property (nonatomic, strong) NSString *stars;

@property (nonatomic, strong) NSString *header;

@property (nonatomic, strong) NSString *footer;

@property (nonatomic, strong) NSString *created;

@property (nonatomic, strong) NSString *avatar_mini;

@property (nonatomic, strong) NSString *avatar_normal;

@property (nonatomic, strong) NSString *avatar_large;
@end
