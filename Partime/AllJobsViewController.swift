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
import MBProgressHUD

class AllJobsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewStyle()
        menuView.delegate = self
        menuView.dataSource = self
        
//        jobsTableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadNewData))
//        jobsTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadNewData))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        clearsSelectionOnViewWillAppear NOT WORK on device
        if let selection = jobsTableView.indexPathForSelectedRow {
            jobsTableView.deselectRowAtIndexPath(selection, animated: true)
        }
        currentCounties = ["不限"] + Location.getCurrentCounties().map({ county in return county["name"].stringValue })
        menuView.reloadBody()
    }
    
    let api = API.shared
    
    @IBOutlet weak var menuView: YXMenuView!
    
    @IBOutlet weak var jobsTableView: UITableView!
    
    var currentCounties: [String]!
    
    var titleForSections = ["类型", "位置"]
    
    let baseLocation = ["不限"]
    var titleForRows = [
        ["不限", "传单派发", "促销导购", "话务客服", "礼仪模特", "老师家教", "服务员", "问卷调查", "审核录入", "地推拉访", "其它"], ["不限"] + Location.getCurrentCounties().map({ county in return county["name"].stringValue })]
    
    var currentSelection = [0, 0]
    var currentPage = 0
    
    
    var jobsData: [JSON] = []
    
    
    func loadNewData() {
        currentPage += 1
        var params: [String: AnyObject] = ["type":"",
                                           "date": "",
                                           "districtid": "",
                                           "page": currentPage]
        
        if currentSelection[0] == 0 {
            params["type"] = ""
        } else {
            params["type"] = "\(currentSelection[0])"
        }
        
        if currentSelection[1] == 0 {
            params["districtid"] = ""
        } else {
            params["districtid"] = Location.getCurrentCounties()[currentSelection[1]-1]["code"].stringValue
        }
//        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        api.getJobs(params) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                if res["status"] == "success" {
                    self.jobsData = res["result"].array!
                    self.jobsTableView.reloadData()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .Failure(let error):
                print(error)
            }
//            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
}


extension AllJobsViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowJobDetailsSegue":
                let controller = segue.destinationViewController as! JobDetailsTableViewController
                let selectedRow = jobsTableView.indexPathForSelectedRow!.row
                controller.id = jobsData[selectedRow]["ptID"].stringValue
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
        
        var params: [String: AnyObject] = ["type":"",
                                           "date": "",
                                           "districtid": "",
                                           "page": currentPage]
        
        if currentSelection[0] == 0 {
            params["type"] = ""
        } else {
            params["type"] = "\(currentSelection[0])"
        }
        
        if currentSelection[1] == 0 {
            params["districtid"] = ""
        } else {
            params["districtid"] = Location.getCurrentCounties()[currentSelection[1]-1]["code"].stringValue
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        api.getJobs(params) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                if res["status"] == "success" {
                    self.jobsData = res["result"].array!
                    self.jobsTableView.reloadData()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .Failure(let error):
                print(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
}

extension AllJobsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobsData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("JobCell", forIndexPath: indexPath) as! JobCell

        let data = jobsData[indexPath.row]
        print(data)
        cell.locationLabel.text = data["district"].stringValue
//        cell.timeLabel.text = data["dateBegin"].stringValue + "~" + data["dateEnd"].stringValue + " " + data["timeBegin"].stringValue + "~" + data["timeEnd"].stringValue
        cell.timeLabel.text = data["dateBegin"].stringValue + " ~ " + data["dateEnd"].stringValue
        cell.salaryLabel.text = "\(data["salary"].stringValue)元/\(data["salarytype"].stringValue)"
        cell.salaryTypeLabel.text = data["salaryWhen"].stringValue
        cell.titleLabel.text = data["title"].stringValue
        cell.logoImage.image = UIImage(named: "Logo")
        return cell
    }
    
}