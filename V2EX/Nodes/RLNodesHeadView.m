//
//  RLNodesHeadView.m
//  V2EX
//
//  Created by ucs on 16/1/11.
//  Copyright © 2016年 ucs. All rights reserved.
//

#import "RLNodesHeadView.h"
#import "RLNode.h"
#import "NSString+extension.h"

@interface RLNodesHeadView()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *startsNumLable;
@property (weak, nonatomic) IBOutlet UILabel *createdTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *topicsNumLable;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLable;
@end

@implementation RLNodesHeadView

+ (instancetype)nodesHeadView {
    RLNodesHeadView *headView = [[[NSBundle mainBundle] loadNibNamed:@"RLNodesHeadView" owner:nil options:nil] firstObject];
    return headView;
}

- (void)setNodeModel:(RLNode *)nodeModel {
    _nodeModel = nodeModel;
    //标题
    _titleLable.text = _nodeModel.title;
    //icon
    NSURL *iconURL = [NSURL URLWithString:[NSString stringWithFormat:@"https:%@", _nodeModel.avatar_normal]];
    [_iconImgV sd_setImageWithURL:iconURL placeholderImage:[UIImage imageNamed:@"blank"]];
    //话题数
    _topicsNumLable.text = [NSString stringWithFormat:@"%@", _nodeModel.topics];
    //星
    _startsNumLable.text = [NSString stringWithFormat:@"★%@", _nodeModel.stars];
    //描述
    _descriptionLable.text = _nodeModel.header;
}

- (void)layoutSubviews {
    //更新高度
    CGFloat height = _descriptionLable.mj_y + _descriptionLable.mj_h + 10;
    self.mj_h = height;
}


@end
