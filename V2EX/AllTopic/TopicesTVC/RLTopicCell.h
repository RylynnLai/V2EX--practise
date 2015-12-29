//
//  RLTopicCell.h
//  V2EX
//
//  Created by ucs on 15/12/22.
//  Copyright © 2015年 ucs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLTopic;
@interface RLTopicCell : UITableViewCell

+ (instancetype)topicCell;
@property (nonatomic, strong) RLTopic *topicModel;
@end
