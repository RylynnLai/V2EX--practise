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

    var recentBtn:UIButton?
    var popBtn:UIButton?
    var currentPageIdx:NSInteger?//当前加载到的页码,20条话题一页(由服务器决定)
    var pageSelected:Int?//最新or最热
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
            
        }
    }
    //MARK: - action方法
    func refreshData() {
        RLTopicsTool.shareRLTopicsTool().currentPageIdx = 1
        self.topics.removeAllObjects()
        loadData()
    }
    func loadMore() {
        if pageSelected == 1 {
            dispatch_async(dispatch_get_main_queue(), {
                [weak self] in
                if let strongSelf = self {
                    strongSelf.tableView.mj_footer.endRefreshing()
                }
            })
        }
        let pageIdx = RLTopicsTool.shareRLTopicsTool().currentPageIdx 
        RLTopicsTool.shareRLTopicsTool().currentPageIdx = pageIdx + 1
        loadData()
    }
    
    func tagClick(btn:UIButton) {
        if btn == recentBtn {
            let footer =  MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: Selector(loadMore()))
            footer.refreshingTitleHidden = true
            self.tableView.mj_footer = footer
            
            recentBtn?.selected = true
            popBtn?.selected = false
            pageSelected = 0
        } else {
            self.tableView.mj_footer = nil
            popBtn?.selected = true
            recentBtn?.selected = false
            pageSelected = 1
        }
        self.tableView.mj_header.beginRefreshing()
    }
    //MARK: - 私有方法
    func loadData() {
        RLTopicsTool.shareRLTopicsTool().topicsWithCompletion({ [weak self]  (topics) in
            if let strongSelf = self {
                strongSelf.topics = topics
            }
            
            
            }, option: nil)
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

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
