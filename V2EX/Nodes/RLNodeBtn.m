//
//  RLNodeBtn.m
//  V2EX
//
//  Created by rylynn lai on 16/1/10.
//  Copyright © 2016年 ucs. All rights reserved.
//

#import "RLNodeBtn.h"


@implementation RLNodeBtn

+ (instancetype)nodeBtnWithNodeModel:(RLNode *)nodeModel {
    RLNodeBtn *nodeBtn = [RLNodeBtn buttonWithType:UIButtonTypeCustom];
    [nodeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    nodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    nodeBtn.titleLabel.minimumScaleFactor = 0.5;
    nodeBtn.titleLabel.numberOfLines = 2;
    nodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [nodeBtn.layer setCornerRadius:12];
    [nodeBtn.layer setMasksToBounds:YES];
    nodeBtn.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [nodeBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    nodeBtn.nodeModel = nodeModel;
    return (RLNodeBtn *)nodeBtn;
}

@end
