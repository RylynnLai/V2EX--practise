//
//  RLTopicCell.m
//  V2EX
//
//  Created by ucs on 15/12/22.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import "RLTopicCell.h"
#import "RLTopic.h"

@interface RLTopicCell ()
@property (weak, nonatomic) IBOutlet UILabel *nodeLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *createdTime;
@property (weak, nonatomic) IBOutlet UIButton *authorBtn;
@property (weak, nonatomic) IBOutlet UILabel *replieNumLable;

@end

@implementation RLTopicCell


- (void)awakeFromNib {
    [super awakeFromNib];
    _authorBtn.layer.cornerRadius = 5;
    _authorBtn.layer.masksToBounds = YES;
    _replieNumLable.layer.cornerRadius = _replieNumLable.mj_h * 0.5;
    _replieNumLable.layer.masksToBounds = YES;
}

- (void)setTopicModel:(RLTopic *)topicModel {
    _topicModel = topicModel;
    _titleLable.text = _topicModel.title;
    //下面两项,如果没数据就是空白
    _contentLable.text = _topicModel.content;
    _createdTime.text = _topicModel.createdTime;
    //-------------------------------------------
    NSURL *iconURL = [NSURL URLWithString:[NSString stringWithFormat:@"https:%@", _topicModel.member.avatar_normal]];
    [_authorBtn sd_setImageWithURL:iconURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"blank"]];
    _nodeLable.text = topicModel.node.name;
    _replieNumLable.text = _topicModel.replies;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
