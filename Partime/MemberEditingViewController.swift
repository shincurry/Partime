//
//  MemberEditingViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/5/23.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import SDWebImage
import MJRefresh

class MemberEditingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = jobTitle
        locationLabel.text = jobLocation
        timeLabel.text = jobTime
        
        var header: MJRefreshNormalHeader!
        switch type! {
        case .Hire:
            header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getJobsHireMembers))
            jobButton.addTarget(self, action: #selector(endRequest), forControlEvents: .TouchUpInside)
            jobButton.setTitle("结束报名", forState: .Normal)
        case .Working:
            header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getJobsWorkingMembers))
            jobButton.addTarget(self, action: #selector(endJob), forControlEvents: .TouchUpInside)
            jobButton.setTitle("结束工作", forState: .Normal)
            memberTableView.allowsSelection = false
        default:
            break
        }
        header.lastUpdatedTimeLabel.hidden = true
        header.stateLabel.hidden = true
        memberTableView.mj_header = header
        
        memberTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadNewData))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        clearsSelectionOnViewWillAppear NOT WORK on device
        if let selection = memberTableView.indexPathForSelectedRow {
            memberTableView.deselectRowAtIndexPath(selection, animated: true)
        }
    }

    
    var id: Int?
    var jobTitle: String?
    var jobLocation: String?
    var jobTime: String?
    
    var type: MyJobsType? {
        didSet {
            switch type! {
            case .Hire:
                getJobsHireMembers()
            case .Working:
                getJobsWorkingMembers()
            default:
                break
            }
        }
    }
    
    var currentPage = 0
    var membersData: [JSON] = []
    let api = API.shared
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var memberTableView: UITableView!
    
    @IBOutlet weak var jobButton: UIButton!
    func endRequest(sender: UIButton) {
        api.endAJob(["access_token": API.token!, "ptID": id!]) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                print(res)
                var alertTitle = ""
                var alertMessage = ""
                if res["status"] == "success" {
                    alertTitle = "成功"
                    alertMessage = "你已成功结束报名"
                    self.jobButton.setTitle("已结束", forState: .Normal)
                } else if res["status"] == "failure" {
                    alertTitle = "失败"
                    alertMessage = "结束报名失败"
                    print("failure")
                }
                let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "知道了", style: .Default, handler: nil)
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            case .Failure(let error):
                print(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    func endJob() {
        api.finishAJob(["access_token": API.token!, "ptID": id!]) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                print(res)
                var alertTitle = ""
                var alertMessage = ""
                if res["status"] == "success" {
                    alertTitle = "成功"
                    alertMessage = "你已成功结束工作"
                    self.jobButton.setTitle("已结束", forState: .Normal)
                } else if res["status"] == "failure" {
                    alertTitle = "失败"
                    alertMessage = "操作失败"
                    print("failure")
                }
                let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "知道了", style: .Default, handler: nil)
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            case .Failure(let error):
                print(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    func getJobsHireMembers() {
        currentPage = 0
        let params: [String: AnyObject] = ["access_token": API.token!,
                      "ptID": id!,
                      "status": "",
                      "page": currentPage+1]
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        api.getJobsHireMembers(params) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                if res["status"] == "success" {
                    self.membersData = res["result"].array!
                    self.memberTableView.reloadData()
                    self.currentPage += 1
                    self.memberTableView.mj_header.endRefreshing()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .Failure(let error):
                print(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    func getJobsWorkingMembers() {
        currentPage = 0
        let params: [String: AnyObject] = ["access_token": API.token!,
                                           "ptID": id!,
                                           "status": "",
                                           "page": currentPage+1]
        api.getJobsWorkingMembers(params) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                print(res)
                if res["status"] == "success" {
                    self.membersData = res["result"].array!
                    self.memberTableView.reloadData()
                    self.currentPage += 1
                    self.memberTableView.mj_header.endRefreshing()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .Failure(let error):
                print(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    
    func loadNewData() {
        let params: [String: AnyObject] = ["access_token": API.token!,
                                           "ptID": id!,
                                           "status": "",
                                           "page": currentPage+1]
        api.getJobs(params) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                if res["status"] == "success" {
                    self.membersData += res["result"].array!
                    self.memberTableView.reloadData()
                    self.currentPage += 1
                    self.memberTableView.mj_footer.endRefreshing()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowLookProfileSegue":
                let controller = segue.destinationViewController as! LookProfileTableViewController
                let selectedRow = memberTableView.indexPathForSelectedRow!.row
                controller.id = (membersData[selectedRow]["userID"].stringValue, membersData[selectedRow]["ptID"].stringValue)
            default:
                break
            }
        }
    }
}

extension MemberEditingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemberCell", forIndexPath: indexPath) as! MemberCell
        let data = membersData[indexPath.row]
        if let imageUri = data["protrait"].string {
            cell.imgView.sd_setImageWithURL(api.getImageUrl(imageUri))
        } else {
            cell.imgView.image = UIImage(named: "DefaultProfile")
        }
        cell.nameLabel.text = data["realname"].stringValue
        switch data["status"].intValue {
        case 33:
            cell.statusLabel.text = "审核中"
            cell.statusColorView.backgroundColor = UIColor.orangeColor()
        case 34:
            cell.statusLabel.text = "已拒绝"
            cell.statusColorView.backgroundColor = UIColor.redColor()
        case 35:
            if type! == .Hire {
                cell.statusLabel.text = "已接受"
                cell.statusColorView.backgroundColor = UIColor(hue: 109.0 / 360.0 , saturation: 0.71, brightness: 0.82, alpha: 1.00)
            } else if type! == .Working {
                cell.statusLabel.text = "准备工作"
                cell.statusColorView.backgroundColor = UIColor.orangeColor()
            }
        case 36:
            cell.statusLabel.text = "已完成"
            cell.statusColorView.backgroundColor = UIColor(hue: 109.0 / 360.0 , saturation: 0.71, brightness: 0.82, alpha: 1.00)
        case 37:
            cell.statusLabel.text = "未完成"
            cell.statusColorView.backgroundColor = UIColor.redColor()
        default:
            cell.statusLabel.text = "未知"
        }
        //        cell.telephoneLabel.text =
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let statusCode = membersData[indexPath.row]["status"].intValue
        if statusCode == 33 || (statusCode == 35 && type! == .Working) {
            return true
        } else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let data = membersData[indexPath.row]
        if type! == .Hire {
            var params: [String: AnyObject] = ["access_token": API.token!,
                                               "ptID": id!,
                                               "userID": data["userID"].stringValue]
            
            let acceptAction = UITableViewRowAction(style: .Normal, title: "录用", handler: { action in
                params["status"] = 35
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.api.dealRequest(params) { response in
                    switch response {
                    case .Success:
                        let res = JSON(data: response.value!)
                        print(res)
                        if res["status"] == "success" {
                            self.membersData[indexPath.row]["status"] = 35
                            self.memberTableView.reloadData()
                        } else if res["status"] == "failure" {
                            print("failure")
                            let alertTitle = "操作失败"
                            let alertMessage = res["error_description"].stringValue
                            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                            let OKAction = UIAlertAction(title: "知道了", style: .Default, handler: nil)
                            alertController.addAction(OKAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    case .Failure(let error):
                        print(error)
                    }
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            })
            acceptAction.backgroundColor = UIColor(hue: 109.0 / 360.0 , saturation: 0.71, brightness: 0.82, alpha: 1.00)
            let refuseAction = UITableViewRowAction(style: .Default, title: "拒绝", handler: { action in
                params["status"] = 34
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.api.dealRequest(params) { response in
                    switch response {
                    case .Success:
                        let res = JSON(data: response.value!)
                        if res["status"] == "success" {
                            self.membersData[indexPath.row]["status"] = 34
                            self.memberTableView.reloadData()
                        } else if res["status"] == "failure" {
                            print("failure")
                            let alertTitle = "操作失败"
                            let alertMessage = res["error_description"].stringValue
                            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                            let OKAction = UIAlertAction(title: "知道了", style: .Default, handler: nil)
                            alertController.addAction(OKAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    case .Failure(let error):
                        print(error)
                    }
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            })
            refuseAction.backgroundColor = UIColor.redColor()
            
            return [refuseAction, acceptAction]
        } else if type! == .Working {
            var params: [String: AnyObject] = ["access_token": API.token!,
                                               "ptID": id!,
                                               "userID": data["userID"].stringValue]
            
            let workedAction = UITableViewRowAction(style: .Normal, title: "已完成", handler: { action in
                params["status"] = 36
                print(params)
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.api.dealWorking(params) { response in
                    switch response {
                    case .Success:
                        let res = JSON(data: response.value!)
                        print(res)
                        if res["status"] == "success" {
                            self.membersData[indexPath.row]["status"] = 36
                            self.memberTableView.reloadData()
                        } else if res["status"] == "failure" {
                            print("failure")
                        }
                    case .Failure(let error):
                        print(error)
                    }
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            })
            workedAction.backgroundColor = UIColor(hue: 109.0 / 360.0 , saturation: 0.71, brightness: 0.82, alpha: 1.00)
            let notWorkAction = UITableViewRowAction(style: .Default, title: "未完成", handler: { action in
                params["status"] = 37
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.api.dealWorking(params) { response in
                    switch response {
                    case .Success:
                        let res = JSON(data: response.value!)
                        print(res)
                        if res["status"] == "success" {
                            self.membersData[indexPath.row]["status"] = 37
                            self.memberTableView.reloadData()
                        } else if res["status"] == "failure" {
                            print("failure")
                        }
                    case .Failure(let error):
                        print(error)
                    }
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            })
            notWorkAction.backgroundColor = UIColor.redColor()
            
            return [notWorkAction, workedAction]
        } else {
            return []
        }
    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if type! == .Hire {
//            performSegueWithIdentifier("ShowLookProfileSegue", sender: self)
//        }
//    }
}