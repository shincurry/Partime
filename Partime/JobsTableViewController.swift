//
//  JobsTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/2/26.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class JobsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = navigationTitle {
            navigationItem.title = title
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    var navigationTitle: String?

    let tempData: [[String]] = [["德克士收银员", "100 元 / 日", "7:00 - 17:00", "重庆"],
        ["发传单", "60 元/日", "13:00-17:00", "重庆理工大学"],
        ["Disco cashier", "100/day", "7:00-17:00", "CQ"],
        ["名字一定要很长来测试 UI", "100 元/日", "7:00-17:00", "重庆"],
        ["发传单", "60 元 / 日", "13:00-17:00", "重庆理工大学"],
        ["Disco cashier", "100/aay", "7:00-17:00", "CQ"],
        ["德克士收银员", "100 元/日", "7:00-17:00", "重庆"],
        ["发传单", "60 元 / 日", "13:00-17:00", "重庆理工大学"],
        ["Disco cashier", "100/day", "7:00-17:00", "CQ"],
        ["德克士收银员", "100 元/日", "7:00-17:00", "重庆"],
        ["发传单", "60 元 / 日", "13:00-17:00", "重庆理工大学"],
        ["Disco cashier", "100/day", "7:00-17:00", "CQ"]]
}

// MARK: - UITableView Delegate and DataSource
extension JobsTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempData.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("jobTableViewCell", forIndexPath: indexPath) as! JobTableViewCell
        let data = tempData[indexPath.row]
        cell.locationLabel.text = data[3]
        cell.timeLabel.text = data[2]
        cell.salaryLabel.text = data[1]
        cell.titleLabel.text = data[0]
        return cell
    }

    
}


