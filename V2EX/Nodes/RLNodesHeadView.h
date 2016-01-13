//
//  RLNodesHeadView.h
//  V2EX
//
//  Created by ucs on 16/1/11.
//  Copyright © 2016年 ucs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLNode;
@interface RLNodesHeadView : UIView
@property (nonatomic, strong) RLNode *nodeModel;
+ (instancetype)nodesHeadView;
@end
