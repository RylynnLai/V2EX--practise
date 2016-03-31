//
//  RLNodesVC.swift
//  V2EX
//
//  Created by LLZ on 16/3/24.
//  Copyright © 2016年 ucs. All rights reserved.
//

import UIKit

class RLNodesVC: UIViewController {

    private lazy var bubblesView:RLBubblesView = {
        var bView = RLBubblesView.init(frame: UIScreen.mainScreen().bounds)
        bView.nodeBtnAction = {[weak self] (nodeModel)->Void in
            if let strongSelf = self {
                let nodeTopicsTVC = RLNodeTopicsTVC.init(style: .Grouped)
                nodeTopicsTVC.nodeModel = nodeModel
                strongSelf.hidesBottomBarWhenPushed = true
                strongSelf.navigationController?.pushViewController(nodeTopicsTVC, animated:true)
                strongSelf.hidesBottomBarWhenPushed = false
            }
        }
        return bView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.bubblesView)
        loadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.hidden = false
    }

    private func loadData()  {
        RLNetWorkManager.shareRLNetWorkManager().requestWithPath("/api/nodes/all.json", success: {[weak self] (response) in
            let allNodes = RLNode.mj_objectArrayWithKeyValuesArray(response)
            var nodeModels:[RLNode] = []
            for node in allNodes {
                let tempNode = node as! RLNode
                if Int(tempNode.topics!)! > 100 {
                nodeModels.append(node as! RLNode)
                }
            }
            if let strongSelf = self {
                strongSelf.bubblesView.nodeModels = nodeModels
            }
            }, failure:{})
    }

}
