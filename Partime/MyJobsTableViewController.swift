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
import MJRefresh

enum AccountType {
    case Employee
    case Employer
    case None
}

enum MyJobsType: Int {
    case Request = 45
    case Publish = 455
    case Hire = 46
    case Working = 47
    case Rate = 1
    case Done = 48
    case None = 0
}


class MyJobsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        switch type.account {
        case .Employee:
            let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getEmployeeJobs))
            header.lastUpdatedTimeLabel.hidden = true
            header.stateLabel.hidden = true
            tableView.mj_header = header
            
        case .Employer:
            let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getEmployerJobs))
            header.lastUpdatedTimeLabel.hidden = true
            header.stateLabel.hidden = true
            tableView.mj_header = header
            if jobsData.count >= 10 {
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(getNewEmployerJobs))
            }
            tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(getNewEmployerJobs))
        default:
            break
        }
        
        
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        clearsSelectionOnViewWillAppear NOT WORK on device
        if let selection = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selection, animated: true)
        }
    }
    
    @IBOutlet weak var jobButton: UIBarButtonItem!
    @IBOutlet weak var navigatorTitle: UINavigationItem!
    let api = API.shared
    
    var currentPage = 0
    var type: (account: AccountType, jobs: MyJobsType) = (.None, .None){
        didSet {
            if !(type.account == .Employer && type.jobs == .Request) {
                jobButton.enabled = false
                jobButton.tintColor = UIColor.clearColor()
            }
            
            if type.account == .Employee {
                switch type.jobs {
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
                getEmployeeJobs()
            } else if type.account == .Employer {
                switch type.jobs {
                case .Request:
                    navigatorTitle.title = "我的发布 - 发布"
                case .Hire:
                    navigatorTitle.title = "我的发布 - 录用"
                case .Working:
                    navigatorTitle.title = "我的发布 - 到岗"
                case .Done:
                    navigatorTitle.title = "我的发布 - 结算"
                default:
                    break
                }
                getEmployerJobs()
                
            }
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
                controller.id = jobsData[selectedRow]["ptID"].intValue
            case "ShowMyJobMemberEditSegue":
                let controller = segue.destinationViewController as! MemberEditingViewController
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    if let cell = tableView.cellForRowAtIndexPath(selectedIndex) as? JobCell {
                        controller.jobTitle = cell.titleLabel.text
                        controller.jobLocation = cell.locationLabel.text
                        controller.jobTime = cell.timeLabel.text
                        controller.id = jobsData[selectedIndex.row]["ptID"].intValue
                        controller.type = type.jobs
                    }
                }
            default:
                break
            }
        }
        
    }
}

extension MyJobsTableViewController {
    func getEmployeeJobs() {
        guard let _ = API.token else {
            tableView.mj_header.endRefreshing()
            return
        }
        let params: [String: String] = ["access_token": API.token!,
                                        "status": "\(type.jobs.rawValue)"]
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        api.getEmployeeJobs(params) { response in
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
            self.tableView.mj_header.endRefreshing()
        }
    }
    func getEmployerJobs() {
        guard let _ = API.token else {
            tableView.mj_header.endRefreshing()
            return
        }
        currentPage = 0
        let params: [String: String] = ["access_token": API.token!,
                                        "status": "\(type.jobs.rawValue)",
                                        "page": "\(currentPage+1)"]
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        api.getEmployerJobs(params) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                print(res)
                if res["status"] == "success" {
                    self.jobsData = res["result"].array!
                    self.currentPage += 1
                    self.tableView.reloadData()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .Failure(let error):
                print(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tableView.mj_header.endRefreshing()
        }
    }
    func getNewEmployerJobs() {
        guard let _ = API.token else {
            tableView.mj_footer.endRefreshing()
            return
        }
        let params: [String: String] = ["access_token": API.token!,
                                        "status": "\(type.jobs.rawValue)",
                                        "page": "\(currentPage+1)"]
        api.getEmployerJobs(params) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                print(res)
                if res["status"] == "success" {
                    self.jobsData += res["result"].array!
                    self.currentPage += 1
                    self.tableView.reloadData()
                    self.tableView.mj_footer.endRefreshing()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .Failure(let error):
                print(error)
            }
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
        
        if !data["district"].stringValue.isEmpty {
            cell.locationLabel.text = data["district"].stringValue
        }
        
        if !data["dateBegin"].stringValue.isEmpty && !data["dateEnd"].stringValue.isEmpty {
            cell.timeLabel.text = data["dateBegin"].stringValue + " ~ " + data["dateEnd"].stringValue
        }
        cell.salaryTypeLabel.text = data["salaryWhen"].stringValue
        cell.titleLabel.text = data["title"].stringValue
        cell.logoImage.image = UIImage(named: "Logo")
        cell.id = (data["ptID"].intValue, data["requestID"].intValue)
        cell.status = data["status"].intValue
        cell.type = self.type
        cell.superController = self
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if type.account == .Employee || type == (.Employer, .Request){
            performSegueWithIdentifier("ShowMyJobDetailsSegue", sender: self)
        } else if type.account == .Employer && type.jobs != .Done {
            performSegueWithIdentifier("ShowMyJobMemberEditSegue", sender: self)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return (type.account == .Employer && type.jobs == .Request)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "删除", handler: { (_, indexPath) in
            let row = indexPath.row
            let id = self.jobsData[row]["ptID"].intValue
            self.api.deleteAJob(["access_token": API.token!, "ptID": id]) { response in
                switch response {
                case .Success:
                    let res = JSON(data: response.value!)
                    if res["status"] == "success" {
                        self.jobsData.removeAtIndex(row)
                        self.tableView.reloadData()
                    } else if res["status"] == "failure" {
                        print("failure")
                    }
                case .Failure(let error):
                    print(error)
                }
            }
        })
        
        return [deleteAction]
    }
    
}