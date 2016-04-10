//
//  RLTopicsTVC.swift
//  V2EX
//
//  Created by LLZ on 16/3/28.
//  Copyright © 2016年 ucs. All rights reserved.
//

import UIKit

//用全局变量代替宏定义
private let tagW = screenW * 0.4
private let tipicesNumOfEachPage = 20

class RLTopicsTVC: UITableViewController {

    private lazy var recentBtn:UIButton = {
        let btn = UIButton.init(type: .System)
        btn.frame = CGRectMake(0, 0, tagW * 0.5, 30)
        btn.setTitle("最近", forState: .Normal)
        btn.setBackgroundImage(UIImage.init(named: "tagBG"), forState: .Selected)
        btn.addTarget(self, action: #selector(RLTopicsTVC.tagClick(UIButton)), forControlEvents: .TouchUpInside)
        return btn
    }()
    private lazy var popBtn:UIButton = {
        let btn = UIButton.init(type: .System)
        btn.frame = CGRectMake(tagW * 0.5 - 1, 0, tagW * 0.5, 30)
        btn.setTitle("最热", forState: .Normal)
        btn.setBackgroundImage(UIImage.init(named: "tagBG"), forState: .Selected)
        btn.addTarget(self, action: Selector("tagClick:"), forControlEvents: .TouchUpInside)
        return btn
    }()
    var currentPageIdx:NSInteger?//当前加载到的页码,20条话题一页(由服务器决定)
    var pageSelected:RLPageSelected = .RecentTopics//最新or最热
    /**保存数据模型数组*/
    private lazy var topics:NSMutableArray = {[]}()
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        //默认会执行一次refreshData()
        header.setRefreshingTarget(self, refreshingAction: Selector("refreshData"))
        self.tableView.mj_header = header
        //默认会执行一次loadMore()
        footer.setRefreshingTarget(self, refreshingAction: Selector("loadMore"))
        footer.refreshingTitleHidden = true
        self.tableView.mj_footer = footer
        
        tagClick(recentBtn)//第一次启动时选中最新
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollViewDidScroll(self.tableView)
    }
    //MARK: - action方法
    private func refreshData() {
        if header.state == .Refreshing {
            RLTopicsTool.shareTopicsTool.currentPageIdx = 1
            self.topics.removeAllObjects()
            loadData()
        }
    }
    private func loadMore() {
//        if pageSelected == .PopTopics {
//            dispatch_async(dispatch_get_main_queue(), {
//                [weak self] in
//                if let strongSelf = self {
//                    strongSelf.tableView.mj_footer.endRefreshing()
//                }
//            })
//        }
        if footer.state == .Refreshing {
            let pageIdx = RLTopicsTool.shareTopicsTool.currentPageIdx
            RLTopicsTool.shareTopicsTool.currentPageIdx = pageIdx + 1
            loadData()
        }
    }
    
    private func tagClick(btn:UIButton) {
        if btn == recentBtn {
//            let footer =  MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: Selector(loadMore()))
//            footer.refreshingTitleHidden = true
//            self.tableView.mj_footer = footer
            
            recentBtn.selected = true
            popBtn.selected = false
            pageSelected = .RecentTopics
        } else {
//            self.tableView.mj_footer = nil
            popBtn.selected = true
            recentBtn.selected = false
            pageSelected = .PopTopics
        }
        header.beginRefreshing()
    }
    //MARK: - 私有方法
    private func loadData() {
        RLTopicsTool.shareTopicsTool.topicsWithCompletion({ [weak self]  (topics) in
            if let strongSelf = self {
                strongSelf.topics = NSMutableArray.init(array: topics)
                //在主线程刷新UI
                dispatch_async(dispatch_get_main_queue(), { 
                    strongSelf.tableView.reloadData()
                    strongSelf.tableView.mj_header.endRefreshing()
                    strongSelf.tableView.mj_footer.endRefreshing()
                })
            }
            }, option: pageSelected)
    }
    
    private func initUI() {
        let tagView = UIView.init(frame: CGRectMake(0, 0, tagW, 30))
        tagView.layer.cornerRadius = 10
        tagView.layer.masksToBounds = true
        tagView.layer.borderWidth = 1
        tagView.layer.borderColor = V2EXGray.CGColor
        tagView.tintColor = V2EXGray
        tagView.addSubview(recentBtn)
        tagView.addSubview(popBtn)
        self.navigationItem.titleView = tagView
        
        //设置返回按钮
        let backBarButtonItem = UIBarButtonItem.init()
        backBarButtonItem.title = ""
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count ?? 0//假如不存在则返回0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:RLTopicCell? = tableView.dequeueReusableCellWithIdentifier("topicCell") as? RLTopicCell
        if cell == nil {
            cell = (RLTopicCell.instantiateFromNib() as! RLTopicCell)
        }
        
        cell?.topicModel = (topics[indexPath.row] as! RLTopic)
        return cell!
    }
    //MARK: -UITableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if pageSelected == .RecentTopics{
            return 105
        } else if pageSelected == .PopTopics {
            return 130
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let topicDetallVC = RLTopicDetailVC.init(nibName: "RLTopicDetailVC", bundle: nil)
        topicDetallVC.topicModel = topics[indexPath.row] as? RLTopic
        
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(topicDetallVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    //MARK: -UIScrollViewDelegate
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.navigationController?.topViewController == self {
            let navBar = self.navigationController?.navigationBar
            if scrollView.contentOffset.y > 0 && navBar?.mj_y == 20 {
                UIView.animateWithDuration(0.5, animations: { 
                    navBar?.mj_y = -(navBar?.mj_h)!
                })
            } else if scrollView.contentOffset.y < 0 && navBar?.mj_y < 0 {
                UIView.animateWithDuration(0.5, animations: {
                    navBar?.mj_y = 20.0
                })
            }
        }
    }
}
