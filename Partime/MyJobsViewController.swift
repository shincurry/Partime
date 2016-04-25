//
//  MyJobsViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/4/18.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import YXMenuView
import SwiftyJSON

class MyJobsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    let api = API.shared
    
    
    let status = ["已报名未审核", "已报名审核通过", "已报名审核未通过", "已取消", "未付款", "完结"]
    
    var currentPage = 0
    
    var jobsData: [JSON]?
    
    @IBOutlet weak var tableView: UITableView!
}


extension MyJobsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = jobsData {
            return data.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyJobsTableViewCell", forIndexPath: indexPath) as! MyJobsTableViewCell
        
        
        let data = jobsData![indexPath.row]
        cell.timeLabel.text = data["begindate"].stringValue
        cell.salaryLabel.text = "\(data["salary"].stringValue) / \(data["salaryunit"].description)"
        cell.titleLabel.text = data["title"].stringValue
        cell.logoImage.image = UIImage(named: "Logo")
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        <#code#>
//    }
}