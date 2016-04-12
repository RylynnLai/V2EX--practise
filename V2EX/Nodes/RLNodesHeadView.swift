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
    
    
    // MARk:setter方法
    var nodeModel:RLNode? {
        didSet{
            //标题
            _titleLable.text = nodeModel!.title;
            //icon (oc swift混用)
            let iconURL = NSURL.init(string: "https:\(nodeModel!.avatar_normal!)")
            _iconImgV.sd_setImageWithURL(iconURL, placeholderImage: UIImage.init(named: "blank"))
            
            //话题数
            _topicsNumLable.text = nodeModel?.topics
            //星
            _startsNumLable.text = "★\(nodeModel!.stars!)"
            //描述
            _descriptionLable.text = nodeModel?.header
        }
        
    }
    override func layoutSubviews() {
        //更新高度
        let height = _descriptionLable.mj_y + _descriptionLable.mj_h + 10
        self.mj_h = height
    }
}
