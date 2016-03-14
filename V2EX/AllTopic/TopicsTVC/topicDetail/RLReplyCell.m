//
//  RLReplyCell.m
//  V2EX
//
//  Created by rylynn lai on 16/3/12.
//  Copyright © 2016年 ucs. All rights reserved.
//

#import "RLReplyCell.h"
#import "RLTopicReply.h"

@interface RLReplyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *authorIcon;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *createdTimeAndThanks;
@property (weak, nonatomic) IBOutlet UIButton *authorBtn;
@end

@implementation RLReplyCell

- (void)setReply:(RLTopicReply *)reply {
    _reply = reply;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
