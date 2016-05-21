//
//  RequestTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/5/21.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD


enum MyJobsType: Int {
    case Request = 45
    case Hire = 46
    case Working = 47
    case Rate = 1
    case Done = 48
    case None = 0
}


class MyJobsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        clearsSelectionOnViewWillAppear NOT WORK on device
        if let selection = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selection, animated: true)
        }
    }
    
    @IBOutlet weak var navigatorTitle: UINavigationItem!
    let api = API.shared
    var type: MyJobsType = .None {
        didSet {
            switch type {
            case .Request:
                navigatorTitle.title = "我的申请 - 报名"
            case .Hire:
                navigatorTitle.title = "我的申请 - 录用"
            case .Working:
                navigatorTitle.title = "我的申请 - 到岗"
            case .Rate:
                fallthrough
            case .Done:
                navigatorTitle.title = "我的申请 - 结算"
            default:
                navigatorTitle.title = ""
            }
            getMyJobs(type)
        }
    }
    var jobsData: [JSON] = []
}

extension MyJobsTableViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowMyJobDetailsSegue":
                let controller = segue.destinationViewController as! JobDetailsTableViewController
                let selectedRow = tableView.indexPathForSelectedRow!.row
                controller.id = jobsData[selectedRow]["ptID"].stringValue
            default:
                break
            }
        }
        
    }
}

extension MyJobsTableViewController {
    func getMyJobs(type: MyJobsType) {
        let params: [String: String] = ["access_token": API.token!,
                                        "status": "\(type.rawValue)"]
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        api.getMyJobs(params) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                print(res)
                if res["status"] == "success" {
                    self.jobsData = res["result"].array!
                    self.tableView.reloadData()
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

extension MyJobsTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobsData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyJobsCell", forIndexPath: indexPath) as! JobCell
        
        let data = jobsData[indexPath.row]
        print(data)
        cell.locationLabel.text = data["district"].stringValue
        //        cell.timeLabel.text = data["dateBegin"].stringValue + "~" + data["dateEnd"].stringValue + " " + data["timeBegin"].stringValue + "~" + data["timeEnd"].stringValue
        cell.timeLabel.text = data["timeBegin"].stringValue + " ~ " + data["timeEnd"].stringValue
        cell.salaryTypeLabel.text = data["salaryWhen"].stringValue
        cell.titleLabel.text = data["title"].stringValue
        cell.logoImage.image = UIImage(named: "Logo")
        cell.id = data["requestID"].intValue
        cell.type = .Request
        cell.superController = self
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
}