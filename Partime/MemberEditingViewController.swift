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
        case .hire:
            header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getJobsHireMembers))
            jobButton.addTarget(self, action: #selector(endRequest), for: .touchUpInside)
            jobButton.setTitle("结束报名", for: UIControlState())
        case .working:
            header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getJobsWorkingMembers))
            jobButton.addTarget(self, action: #selector(endJob), for: .touchUpInside)
            jobButton.setTitle("结束工作", for: UIControlState())
            memberTableView.allowsSelection = false
        default:
            break
        }
        header.lastUpdatedTimeLabel.isHidden = true
        header.stateLabel.isHidden = true
//        memberTableView.mj_header = header
        
        memberTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadNewData))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        clearsSelectionOnViewWillAppear NOT WORK on device
        if let selection = memberTableView.indexPathForSelectedRow {
            memberTableView.deselectRow(at: selection, animated: true)
        }
    }

    
    var id: Int?
    var jobTitle: String?
    var jobLocation: String?
    var jobTime: String?
    
    var type: MyJobsType? {
        didSet {
            switch type! {
            case .hire:
                getJobsHireMembers()
            case .working:
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
    func endRequest(_ sender: UIButton) {
        api.endAJob(["access_token": API.token! as AnyObject, "ptID": id! as AnyObject]) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                print(res)
                var alertTitle = ""
                var alertMessage = ""
                if res["status"] == "success" {
                    alertTitle = "成功"
                    alertMessage = "你已成功结束报名"
                    self.jobButton.setTitle("已结束", for: UIControlState())
                } else if res["status"] == "failure" {
                    alertTitle = "失败"
                    alertMessage = "结束报名失败"
                    print("failure")
                }
                let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "知道了", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func endJob() {
        api.finishAJob(["access_token": API.token! as AnyObject, "ptID": id! as AnyObject]) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                print(res)
                var alertTitle = ""
                var alertMessage = ""
                if res["status"] == "success" {
                    alertTitle = "成功"
                    alertMessage = "你已成功结束工作"
                    self.jobButton.setTitle("已结束", for: UIControlState())
                } else if res["status"] == "failure" {
                    alertTitle = "失败"
                    alertMessage = "操作失败"
                    print("failure")
                }
                let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "知道了", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func getJobsHireMembers() {
        currentPage = 0
        let params: [String: AnyObject] = ["access_token": API.token! as AnyObject,
                      "ptID": id! as AnyObject,
                      "status": "" as AnyObject,
                      "page": (currentPage+1) as AnyObject]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        api.getJobsHireMembers(params) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                if res["status"] == "success" {
                    self.membersData = res["result"].array!
                    self.memberTableView.reloadData()
                    self.currentPage += 1
//                    self.memberTableView.mj_header.endRefreshing()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func getJobsWorkingMembers() {
        currentPage = 0
        let params: [String: AnyObject] = ["access_token": API.token! as AnyObject,
                                           "ptID": id! as AnyObject,
                                           "status": "" as AnyObject,
                                           "page": (currentPage+1) as AnyObject]
        api.getJobsWorkingMembers(params) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                print(res)
                if res["status"] == "success" {
                    self.membersData = res["result"].array!
                    self.memberTableView.reloadData()
                    self.currentPage += 1
//                    self.memberTableView.mj_header.endRefreshing()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    
    func loadNewData() {
        let params: [String: AnyObject] = ["access_token": API.token! as AnyObject,
                                           "ptID": id! as AnyObject,
                                           "status": "" as AnyObject,
                                           "page": (currentPage+1) as AnyObject]
        api.getJobs(params) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                if res["status"] == "success" {
                    self.membersData += res["result"].array!
                    self.memberTableView.reloadData()
                    self.currentPage += 1
                    self.memberTableView.mj_footer.endRefreshing()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowLookProfileSegue":
                let controller = segue.destination as! LookProfileTableViewController
                let selectedRow = memberTableView.indexPathForSelectedRow!.row
                controller.id = (membersData[selectedRow]["userID"].stringValue, membersData[selectedRow]["ptID"].stringValue)
            default:
                break
            }
        }
    }
}

extension MemberEditingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
        let data = membersData[indexPath.row]
        if let imageUri = data["protrait"].string {
            cell.imgView.sd_setImage(with: api.getImageUrl(imageUri))
        } else {
            cell.imgView.image = UIImage(named: "DefaultProfile")
        }
        cell.nameLabel.text = data["realname"].stringValue
        switch data["status"].intValue {
        case 33:
            cell.statusLabel.text = "审核中"
            cell.statusColorView.backgroundColor = UIColor.orange
        case 34:
            cell.statusLabel.text = "已拒绝"
            cell.statusColorView.backgroundColor = UIColor.red
        case 35:
            if type! == .hire {
                cell.statusLabel.text = "已接受"
                cell.statusColorView.backgroundColor = UIColor(hue: 109.0 / 360.0 , saturation: 0.71, brightness: 0.82, alpha: 1.00)
            } else if type! == .working {
                cell.statusLabel.text = "准备工作"
                cell.statusColorView.backgroundColor = UIColor.orange
            }
        case 36:
            cell.statusLabel.text = "已完成"
            cell.statusColorView.backgroundColor = UIColor(hue: 109.0 / 360.0 , saturation: 0.71, brightness: 0.82, alpha: 1.00)
        case 37:
            cell.statusLabel.text = "未完成"
            cell.statusColorView.backgroundColor = UIColor.red
        default:
            cell.statusLabel.text = "未知"
        }
        //        cell.telephoneLabel.text =
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let statusCode = membersData[indexPath.row]["status"].intValue
        if statusCode == 33 || (statusCode == 35 && type! == .working) {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let data = membersData[indexPath.row]
        if type! == .hire {
            var params: [String: AnyObject] = ["access_token": API.token! as AnyObject,
                                               "ptID": id! as AnyObject,
                                               "userID": data["userID"].stringValue as AnyObject]
            
            let acceptAction = UITableViewRowAction(style: .normal, title: "录用", handler: { action in
                params["status"] = 35 as AnyObject?
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.api.dealRequest(params) { response in
                    switch response {
                    case .success:
                        let res = JSON(data: response.value!)
                        print(res)
                        if res["status"] == "success" {
                            self.membersData[indexPath.row]["status"] = 35
                            self.memberTableView.reloadData()
                        } else if res["status"] == "failure" {
                            print("failure")
                            let alertTitle = "操作失败"
                            let alertMessage = res["error_description"].stringValue
                            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "知道了", style: .default, handler: nil)
                            alertController.addAction(OKAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    case .failure(let error):
                        print(error)
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            })
            acceptAction.backgroundColor = UIColor(hue: 109.0 / 360.0 , saturation: 0.71, brightness: 0.82, alpha: 1.00)
            let refuseAction = UITableViewRowAction(style: .default, title: "拒绝", handler: { action in
                params["status"] = 34 as AnyObject?
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.api.dealRequest(params) { response in
                    switch response {
                    case .success:
                        let res = JSON(data: response.value!)
                        if res["status"] == "success" {
                            self.membersData[indexPath.row]["status"] = 34
                            self.memberTableView.reloadData()
                        } else if res["status"] == "failure" {
                            print("failure")
                            let alertTitle = "操作失败"
                            let alertMessage = res["error_description"].stringValue
                            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "知道了", style: .default, handler: nil)
                            alertController.addAction(OKAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    case .failure(let error):
                        print(error)
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            })
            refuseAction.backgroundColor = UIColor.red
            
            return [refuseAction, acceptAction]
        } else if type! == .working {
            var params: [String: AnyObject] = ["access_token": API.token! as AnyObject,
                                               "ptID": id! as AnyObject,
                                               "userID": data["userID"].stringValue as AnyObject]
            
            let workedAction = UITableViewRowAction(style: .normal, title: "已完成", handler: { action in
                params["status"] = 36 as AnyObject?
                print(params)
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.api.dealWorking(params) { response in
                    switch response {
                    case .success:
                        let res = JSON(data: response.value!)
                        print(res)
                        if res["status"] == "success" {
                            self.membersData[indexPath.row]["status"] = 36
                            self.memberTableView.reloadData()
                        } else if res["status"] == "failure" {
                            print("failure")
                        }
                    case .failure(let error):
                        print(error)
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            })
            workedAction.backgroundColor = UIColor(hue: 109.0 / 360.0 , saturation: 0.71, brightness: 0.82, alpha: 1.00)
            let notWorkAction = UITableViewRowAction(style: .default, title: "未完成", handler: { action in
                params["status"] = 37 as AnyObject?
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.api.dealWorking(params) { response in
                    switch response {
                    case .success:
                        let res = JSON(data: response.value!)
                        print(res)
                        if res["status"] == "success" {
                            self.membersData[indexPath.row]["status"] = 37
                            self.memberTableView.reloadData()
                        } else if res["status"] == "failure" {
                            print("failure")
                        }
                    case .failure(let error):
                        print(error)
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            })
            notWorkAction.backgroundColor = UIColor.red
            
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
