//
//  RLTabbarVC.swift
//  V2EX
//
//  Created by LLZ on 16/4/11.
//  Copyright © 2016年 ucs. All rights reserved.
//

import UIKit

class RLTabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        let nav1 = UINavigationController.init(rootViewController: RLTopicsTVC())
        nav1.tabBarItem.title = "V2EX"
        self.addChildViewController(nav1)
        
        let nav2 = UINavigationController.init(rootViewController: RLNodesVC())
        nav2.tabBarItem.title = "节点"
        self.addChildViewController(nav2)
    }
    //更改统一UI样式
    private func initUI() {
        let bar = UINavigationBar .appearance()
        bar.tintColor = V2EXGray
    }

}
