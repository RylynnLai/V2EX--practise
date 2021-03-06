//
//  RLNodeTopicsTVC.swift
//  V2EX
//
//  Created by LLZ on 16/3/22.
//  Copyright © 2016年 ucs. All rights reserved.
//

import UIKit

class RLNodeTopicsTVC: UITableViewController {

    
    var nodeModel:RLNode?
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshBackNormalFooter()
    //懒加载
    private lazy var topics:NSMutableArray = {[]}()
    private lazy var headView:RLNodesHeadView = {
        return RLNodesHeadView.instantiateFromNib() as! RLNodesHeadView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MJRefresh
        header.setRefreshingTarget(self, refreshingAction: #selector(RLNodeTopicsTVC.refreshData))
        self.tableView.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(RLNodeTopicsTVC.loadMore))
        footer.setTitle("再拉也没用,Livid只给了我10条数据", forState: .Refreshing)
        self.tableView.mj_footer = footer
        
        loadData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //只能放在这,配合table的头视图代理方法,自适应高度
        self.tableView.tableHeaderView = self.headView
    }
  
    func loadData() {
        self.title = nodeModel?.title
        self.headView.nodeModel = nodeModel
        //获取完整的节点数据
        let path = "/api/nodes/show.json?id=\(nodeModel!.ID!)"
        RLNetWorkManager.defaultNetWorkManager.requestWithPath(path, success: { [weak self] (response) -> Void in
            if let strongSelf = self {//如果self还没被释放（即当前还是强引用）
                strongSelf.nodeModel = RLNode.mj_objectWithKeyValues(response)
                strongSelf.headView.nodeModel = strongSelf.nodeModel
                strongSelf.tableView.mj_header.beginRefreshing()
            }
            }, failure:{ () -> Void in
        })
    }
    //下拉刷新
    func refreshData() {
        if nodeModel != nil {
            RLNetWorkManager.defaultNetWorkManager.requestNodeTopicssWithID(nodeModel!.ID!, success: { [weak self] (response) -> Void in
                if let strongSelf = self {//如果self还没被释放（即当前还是强引用）
                    strongSelf.topics = RLTopic.mj_objectArrayWithKeyValuesArray(response)
                    strongSelf.tableView.mj_header.endRefreshing()
                    strongSelf.tableView.reloadData()
                }
                }, failure: { () -> Void in
                self.tableView.mj_header.endRefreshing()
            })
        }
    }
    //上拉加载更多
    func loadMore() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { [weak self] () -> Void in
            if let strongSelf = self {//如果self还没被释放（即当前还是强引用）
                strongSelf.tableView.mj_footer.endRefreshing()
            }
        }
    }
    //MARK: -Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("nodeTopicCell")
        if cell == nil {
        cell = (RLTopicCell.instantiateFromNib() as! UITableViewCell)
        }
        if topics.count > 0 {
            let topicCell:RLTopicCell = cell as! RLTopicCell
            topicCell.topicModel = (self.topics[indexPath.row] as! RLTopic)
        }
        return cell!
    }


    //MARK: -UITableViewDelegate
    override func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return headView.mj_h
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headView
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if topics.count > 0 {
            let topicDetallVC = RLTopicDetailVC.init(nibName: NSStringFromClass(RLTopicDetailVC), bundle: nil)
            topicDetallVC.topicModel = self.topics[indexPath.row] as? RLTopic
            
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(topicDetallVC, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
    }
}
