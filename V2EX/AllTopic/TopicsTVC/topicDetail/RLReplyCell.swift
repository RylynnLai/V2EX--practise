//
//  RLReplyCell.swift
//  V2EX
//
//  Created by LLZ on 16/3/28.
//  Copyright © 2016年 ucs. All rights reserved.
//

import UIKit

class RLReplyCell: UITableViewCell {
    
    var reply:RLTopicReply? 
    
    @IBOutlet weak var indexLable: UILabel!
    
    @IBOutlet weak var authorIcon: UIImageView!
    
    @IBOutlet weak var contentLable: UILabel!
    
    @IBOutlet weak var createdTimeAndThanks: UILabel!
    
    @IBOutlet weak var authorBtn: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
