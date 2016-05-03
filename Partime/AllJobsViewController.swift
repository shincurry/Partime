//
//  AllJobsViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/3/12.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import YXMenuView
import SwiftyJSON
import MJRefresh

class AllJobsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewStyle()
        menuView.delegate = self
        menuView.dataSource = self
        
        jobsTableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadNewData))
        
        print(titleForRows)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        clearsSelectionOnViewWillAppear NOT WORK on device
        if let selection = jobsTableView.indexPathForSelectedRow {
            jobsTableView.deselectRowAtIndexPath(selection, animated: true)
        }
        currentCounties = Location.getCurrentCounties()
//        menuView.reloadData()
    }
    
    let api = API.shared
    
    @IBOutlet weak var menuView: YXMenuView!
    
    @IBOutlet weak var jobsTableView: UITableView!
    
    var currentCounties: [String]!
    
    var titleForSections = ["类型", "位置"]
    var titleForRows = [
        ["不限", "传单派发", "促销导购", "话务客服", "礼仪模特", "老师家教", "服务员", "问卷调查", "审核录入", "地推拉访", "其它"], Location.getCurrentCounties()]
    
    var currentSelection = [0, 0]
    var currentPage = 0
    
    
    var jobsData: [JSON]?
    
    
    func loadNewData() {
        print("loadNewData")
        currentPage += 1
        var params = ["type": "\(currentSelection[0])",
                      "page": "\(currentPage)",
                      "country": ""]
        if currentSelection[0] == 0 {
            params["type"] = ""
        }
        api.getJobs(params) { result in
            switch result {
            case .Success:
                if let value = result.value {
                    let newData = self.jobsData! + JSON(data: value).array!
                    self.jobsData = newData
                    print(self.jobsData)
                    self.jobsTableView.reloadData()
                }
            case .Failure(let error):
                print(error)
            }
        }
        jobsTableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadNewData))
    }
}


extension AllJobsViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowJobDetailsSegue":
                let controller = segue.destinationViewController as! JobDetailsTableViewController
                let selectedRow = jobsTableView.indexPathForSelectedRow!.row
                controller.id = jobsData![selectedRow]["id"].stringValue
//                controller.jobData = jobsData!.array![selectedRow]
            default:
                break
            }
        }

    }
}

extension AllJobsViewController {
    private func initialViewStyle() {
        automaticallyAdjustsScrollViewInsets = false
        if let navigator = navigationController {
            navigator.navigationBar.barTintColor = Theme.mainColor
        }
        menuView.tintColor = Theme.mainColor
    }
}


extension AllJobsViewController: YXMenuViewDelegate, YXMenuViewDataSource {
    func numberOfSectionsInYXMenuView(menuView: YXMenuView) -> Int {
        return titleForSections.count
    }
    func menuView(menuView: YXMenuView, numberOfRowsInSection section: Int) -> Int {
        return titleForRows[section].count
    }
    func menuView(menuView: YXMenuView, titleForHeaderInSection section: Int) -> String {
        return titleForSections[section]
    }
    func menuView(menuView: YXMenuView, titleForRowAtIndexPath indexPath: NSIndexPath) -> String {
        return titleForRows[indexPath.section][indexPath.row]
    }
    func menuView(menuView: YXMenuView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentSelection[indexPath.section] = indexPath.row
        currentPage = 1
        var params = ["type": "\(currentSelection[0])",
                      "page": "\(currentPage)",
                      "country": ""]
        if currentSelection[0] == 0 {
            params["type"] = ""
        }
        
        api.getJobs(params) { response in
            switch response {
            case .Success:
                self.jobsData = JSON(data: response.value!).array!
                self.jobsTableView.reloadData()
            case .Failure(let error):
                print(error)
            }

        }
    }
}

extension AllJobsViewController: UITableViewDelegate, UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("JobTableViewCell", forIndexPath: indexPath) as! JobTableViewCell

        let data = jobsData![indexPath.row]
        print(data)
        cell.locationLabel.text = data["cityid"].stringValue
        cell.timeLabel.text = data["createtime"].stringValue
        cell.salaryLabel.text = "\(data["salary"].stringValue) 元/ \(data["salaryunit"].stringValue)"
        cell.titleLabel.text = data["title"].stringValue
        cell.logoImage.image = UIImage(named: "Logo")
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}