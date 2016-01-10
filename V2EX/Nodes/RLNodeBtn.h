//
//  RLNodeBtn.h
//  V2EX
//
//  Created by rylynn lai on 16/1/10.
//  Copyright © 2016年 ucs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLNode;
@interface RLNodeBtn : UIButton

@property (nonatomic, strong) RLNode *nodeModel;
+ (instancetype)nodeBtnWithNodeModel:(RLNode *)nodeModel;
@end
