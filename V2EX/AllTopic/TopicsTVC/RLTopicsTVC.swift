//
//  RLTopicsTVC.swift
//  V2EX
//
//  Created by LLZ on 16/3/28.
//  Copyright © 2016年 ucs. All rights reserved.
//

import UIKit

//用全局变量代替宏定义
private let tagW = UIScreen.mainScreen().bounds.width * 0.4
private let tipicesNumOfEachPage = 20

class RLTopicsTVC: UITableViewController {

    private lazy var recentBtn:UIButton = {
        let btn = UIButton.init(type: .System)
        btn.frame = CGRectMake(0, 0, tagW * 0.5, 30)
        btn.setTitle("最近", forState: .Normal)
        btn.setBackgroundImage(UIImage.init(named: "tagBG"), forState: .Selected)
        btn.addTarget(self, action: #selector(tagClick(_:)), forControlEvents: .TouchUpInside)
        return btn
    }()
    private lazy var popBtn:UIButton = {
        let btn = UIButton.init(type: .System)
        btn.frame = CGRectMake(tagW * 0.5 - 1, 0, tagW * 0.5, 30)
        btn.setTitle("最热", forState: .Normal)
        btn.setBackgroundImage(UIImage.init(named: "tagBG"), forState: .Selected)
        btn.addTarget(self, action: #selector(tagClick(_:)), forControlEvents: .TouchUpInside)
        return btn
    }()
    var currentPageIdx:NSInteger?//当前加载到的页码,20条话题一页(由服务器决定)
    var pageSelected:RLPageSelected = .RecentTopics//最新or最热
    /**保存数据模型数组*/
    private lazy var topics:NSMutableArray = {[]}()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: Selector(refreshData()))
        let footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: Selector(loadMore()))
        footer.refreshingTitleHidden = true
        self.tableView.mj_footer = footer
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollViewDidScroll(self.tableView)
        
        //第一次加载出现时显示最近话题页面,只执行一次
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            [weak self] in
            if let strongSelf = self {
                strongSelf.tagClick(strongSelf.recentBtn)
            }
        }
    }
    //MARK: - action方法
    func refreshData() {
        RLTopicsTool.shareTopicsTool.currentPageIdx = 1
        self.topics.removeAllObjects()
        loadData()
    }
    func loadMore() {
        if pageSelected == .PopTopics {
            dispatch_async(dispatch_get_main_queue(), {
                [weak self] in
                if let strongSelf = self {
                    strongSelf.tableView.mj_footer.endRefreshing()
                }
            })
        }
        let pageIdx = RLTopicsTool.shareTopicsTool.currentPageIdx
        RLTopicsTool.shareTopicsTool.currentPageIdx = pageIdx + 1
        loadData()
    }
    
    func tagClick(btn:UIButton) {
        if btn == recentBtn {
            let footer =  MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: Selector(loadMore()))
            footer.refreshingTitleHidden = true
            self.tableView.mj_footer = footer
            
            recentBtn.selected = true
            popBtn.selected = false
            pageSelected = .RecentTopics
        } else {
            self.tableView.mj_footer = nil
            popBtn.selected = true
            recentBtn.selected = false
            pageSelected = .PopTopics
        }
        self.tableView.mj_header.beginRefreshing()
    }
    //MARK: - 私有方法
    func loadData() {
        RLTopicsTool.shareTopicsTool.topicsWithCompletion({ [weak self]  (topics) in
            if let strongSelf = self {
                strongSelf.topics = NSMutableArray.init(array: topics)
                dispatch_async(dispatch_get_main_queue(), { 
                    strongSelf.tableView.reloadData()
                    strongSelf.tableView.mj_header.endRefreshing()
                    strongSelf.tableView.mj_footer.endRefreshing()
                })
            }
            }, option: pageSelected)
    }
    
    func initUI() {
        let tagView = UIView.init(frame: CGRectMake(0, 0, tagW, 30))
        tagView.layer.cornerRadius = 10;
        tagView.layer.masksToBounds = true;
        tagView.layer.borderWidth = 1;
//        tagView.layer.borderColor = V2EXGray.CGColor;
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
