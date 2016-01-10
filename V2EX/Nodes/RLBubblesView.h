//
//  RLBubblesView.h
//  V2EX
//
//  Created by ucs on 16/1/7.
//  Copyright © 2016年 ucs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLNode;
typedef void(^nodeBtnAction)(RLNode *nodeModel);
@interface RLBubblesView : UIScrollView
@property (nonatomic, strong) NSArray *nodeModels;
@property (nonatomic, copy) nodeBtnAction clickAction;
@end
