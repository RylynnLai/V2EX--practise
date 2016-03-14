//
//  RLReplyCell.h
//  V2EX
//
//  Created by rylynn lai on 16/3/12.
//  Copyright © 2016年 ucs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RLTopicReply;
@interface RLReplyCell : UITableViewCell
@property (nonatomic, strong) RLTopicReply *reply;

@property (weak, nonatomic) IBOutlet UILabel *indexLable;
@end
