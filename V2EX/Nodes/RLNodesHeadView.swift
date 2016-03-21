//
//  RLNodesHeadView.swift
//  V2EX
//
//  Created by LLZ on 16/3/15.
//  Copyright © 2016年 ucs. All rights reserved.
//

import UIKit

class RLNodesHeadView: UIView {

    
    @IBOutlet weak var _titleLable: UILabel!
    @IBOutlet weak var _iconImgV: UIImageView!
    @IBOutlet weak var _startsNumLable: UILabel!
    @IBOutlet weak var _topicsNumLable: UILabel!
    @IBOutlet weak var _descriptionLable: UILabel!
    
    
    override func layoutSubviews() {
        //更新高度
        let height = _descriptionLable.mj_y + _descriptionLable.mj_h + 10
        self.mj_h = height
    }
}
