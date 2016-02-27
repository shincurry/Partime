//
//  JobDetailsTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/2/27.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class JobDetailsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tempData()
        tableView.backgroundColor = Theme.backgroundColor
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension JobDetailsTableViewController {
    func tempData() {
        titleLabel.text = "标题取这么长真的好嘛？"
        locationLabel.text = "重庆理工大学"
        timeLabel.text = "2016-1-1"
        rateLabel.text = RateStar(score: 4).getStars()
        
    }
    
//    private func load(job: Job) {
//        titleLabel.text = job.title
//        locationLabel.text = job.location
//        
//    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if indexPath.section == 0 && indexPath.row == 0 {
            
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 12
    }
}
