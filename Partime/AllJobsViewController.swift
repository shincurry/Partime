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

enum QuickAccess: Int {
    case lsjj = 5
    case cxdg = 2
    case cdff = 1
    case other = 10
}

class AllJobsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewStyle()
        menuView.delegate = self
        menuView.dataSource = self
        
//        jobsTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadNewData))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        clearsSelectionOnViewWillAppear NOT WORK on device
        if let selection = jobsTableView.indexPathForSelectedRow {
            jobsTableView.deselectRow(at: selection, animated: true)
        }
        currentCounties = ["不限"] + Location.getCurrentCounties().map({ county in return county["name"].stringValue })
        menuView.reloadBody()
    }
    
    let api = API.shared
    
    @IBOutlet weak var menuView: YXMenuView!
    
    @IBOutlet weak var jobsTableView: UITableView!
    
    var currentCounties: [String]!
    
    var titleForSections = ["类型", "位置", "时间"]
    
    let baseLocation = ["不限"]
    var titleForRows = [
        ["不限", "传单派发", "促销导购", "话务客服", "礼仪模特", "老师家教", "服务员", "问卷调查", "审核录入", "地推拉访", "其它"], ["不限"] + Location.getCurrentCounties().map({ county in return county["name"].stringValue }), ["不限", "最近一周", "最近两周", "最近一个月"]]
    var currentSelection = [0, 0, 0]
    var currentPage = 0
    
    
    var jobsData: [JSON] = []
    
    func loadNewData() {
        var params: [String: AnyObject] = ["type":"" as AnyObject,
                                           "date": "" as AnyObject,
                                           "districtid": "" as AnyObject,
                                           "page": currentPage+1 as AnyObject]
        
        if currentSelection[0] == 0 {
            params["type"] = "" as AnyObject?
        } else {
            params["type"] = "\(currentSelection[0])" as AnyObject
        }
        
        if currentSelection[1] == 0 {
            params["districtid"] = "" as AnyObject?
        } else {
            params["districtid"] = Location.getCurrentCounties()[currentSelection[1]-1]["code"].stringValue as AnyObject
        }
//        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        api.getJobs(params) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                if res["status"] == "success" {
                    self.jobsData += res["result"].array!
                    self.jobsTableView.reloadData()
                    self.currentPage += 1
                    self.jobsTableView.mj_footer.endRefreshing()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .failure(let error):
                print(error)
            }
//            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    func quickAccess(_ type: QuickAccess) {
        currentPage = 1
        currentSelection[0] = type.rawValue
        filtersJob()
    }
    
    func filtersJob() {
        var params: [String: AnyObject] = ["type":"" as AnyObject,
                                           "date": "" as AnyObject,
                                           "districtid": "" as AnyObject,
                                           "page": currentPage as AnyObject]
        
        if currentSelection[0] == 0 {
            params["type"] = "" as AnyObject?
        } else {
            params["type"] = "\(currentSelection[0])" as AnyObject
        }
        
        if currentSelection[1] == 0 {
            params["districtid"] = "" as AnyObject?
        } else {
            params["districtid"] = Location.getCurrentCounties()[currentSelection[1]-1]["code"].stringValue as AnyObject
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        api.getJobs(params) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                if res["status"] == "success" {
                    self.jobsData = res["result"].array!
                    self.jobsTableView.reloadData()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}


extension AllJobsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowJobDetailsSegue":
                let controller = segue.destination as! JobDetailsTableViewController
                let selectedRow = jobsTableView.indexPathForSelectedRow!.row
                controller.id = jobsData[selectedRow]["ptID"].intValue
            default:
                break
            }
        }

    }
}

extension AllJobsViewController {
    fileprivate func initialViewStyle() {
        automaticallyAdjustsScrollViewInsets = false
        if let navigator = navigationController {
            navigator.navigationBar.barTintColor = Theme.mainColor
        }
        menuView.tintColor = Theme.mainColor
    }
}


extension AllJobsViewController: YXMenuViewDelegate, YXMenuViewDataSource {
    func numberOfSectionsInYXMenuView(_ menuView: YXMenuView) -> Int {
        return titleForSections.count
    }
    func menuView(_ menuView: YXMenuView, numberOfRowsInSection section: Int) -> Int {
        return titleForRows[section].count
    }
    func menuView(_ menuView: YXMenuView, titleForHeaderInSection section: Int) -> String {
        return titleForSections[section]
    }
    func menuView(_ menuView: YXMenuView, titleForRowAtIndexPath indexPath: IndexPath) -> String {
        return titleForRows[indexPath.section][indexPath.row]
    }
    func menuView(_ menuView: YXMenuView, didSelectRowAtIndexPath indexPath: IndexPath) {
        currentSelection[indexPath.section] = indexPath.row
        currentPage = 1
        
        filtersJob()
    }
}

extension AllJobsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath) as! JobCell

        let data = jobsData[indexPath.row]
        if !data["district"].stringValue.isEmpty {
            cell.locationLabel.text = data["district"].stringValue
        }
//        cell.timeLabel.text = data["dateBegin"].stringValue + "~" + data["dateEnd"].stringValue + " " + data["timeBegin"].stringValue + "~" + data["timeEnd"].stringValue
        
        if !data["dateBegin"].stringValue.isEmpty && !data["dateEnd"].stringValue.isEmpty {
            cell.timeLabel.text = data["dateBegin"].stringValue + " ~ " + data["dateEnd"].stringValue
        }
        cell.salaryLabel!.text = "\(data["salary"].stringValue)元/\(data["salaryType"].stringValue)"
        cell.salaryTypeLabel.text = data["salaryWhen"].stringValue
        cell.titleLabel.text = data["title"].stringValue
        cell.logoImage.image = UIImage(named: "Logo")
        return cell
    }
    
}
