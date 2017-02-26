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
    case employee
    case employer
    case none
}

enum MyJobsType: Int {
    case request = 45
    case publish = 455
    case hire = 46
    case working = 47
    case rate = 1
    case done = 48
    case none = 0
}


class MyJobsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        switch type.account {
        case .employee:
            let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getEmployeeJobs))
            header?.lastUpdatedTimeLabel.isHidden = true
            header?.stateLabel.isHidden = true
//            tableView.mj_header = header
            
        case .employer:
            let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getEmployerJobs))
            header?.lastUpdatedTimeLabel.isHidden = true
            header?.stateLabel.isHidden = true
//            tableView.mj_header = header
            if jobsData.count >= 10 {
                tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(getNewEmployerJobs))
            }
            tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(getNewEmployerJobs))
        default:
            break
        }
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        clearsSelectionOnViewWillAppear NOT WORK on device
        if let selection = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selection, animated: true)
        }
    }
    
    @IBOutlet weak var jobButton: UIBarButtonItem!
    @IBOutlet weak var navigatorTitle: UINavigationItem!
    let api = API.shared
    
    var currentPage = 0
    var type: (account: AccountType, jobs: MyJobsType) = (.none, .none){
        didSet {
            if !(type.account == .employer && type.jobs == .request) {
                jobButton.isEnabled = false
                jobButton.tintColor = UIColor.clear
            }
            
            if type.account == .employee {
                switch type.jobs {
                case .request:
                    navigatorTitle.title = "我的申请 - 报名"
                case .hire:
                    navigatorTitle.title = "我的申请 - 录用"
                case .working:
                    navigatorTitle.title = "我的申请 - 到岗"
                case .rate:
                    fallthrough
                case .done:
                    navigatorTitle.title = "我的申请 - 结算"
                default:
                    navigatorTitle.title = ""
                }
                getEmployeeJobs()
            } else if type.account == .employer {
                switch type.jobs {
                case .request:
                    navigatorTitle.title = "我的发布 - 发布"
                case .hire:
                    navigatorTitle.title = "我的发布 - 录用"
                case .working:
                    navigatorTitle.title = "我的发布 - 到岗"
                case .done:
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowMyJobDetailsSegue":
                let controller = segue.destination as! JobDetailsTableViewController
                let selectedRow = tableView.indexPathForSelectedRow!.row
                controller.id = jobsData[selectedRow]["ptID"].intValue
            case "ShowMyJobMemberEditSegue":
                let controller = segue.destination as! MemberEditingViewController
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    if let cell = tableView.cellForRow(at: selectedIndex) as? JobCell {
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
//            tableView.mj_header.endRefreshing()
            return
        }
        let params: [String: String] = ["access_token": API.token!,
                                        "status": "\(type.jobs.rawValue)"]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        api.getEmployeeJobs(params as [String : AnyObject]) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                print(res)
                if res["status"] == "success" {
                    self.jobsData = res["result"].array!
                    self.tableView.reloadData()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
//            self.tableView.mj_header.endRefreshing()
        }
    }
    func getEmployerJobs() {
        guard let _ = API.token else {
//            tableView.mj_header.endRefreshing()
            return
        }
        currentPage = 0
        let params: [String: String] = ["access_token": API.token!,
                                        "status": "\(type.jobs.rawValue)",
                                        "page": "\(currentPage+1)"]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        api.getEmployerJobs(params as [String : AnyObject]) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                print(res)
                if res["status"] == "success" {
                    self.jobsData = res["result"].array!
                    self.currentPage += 1
                    self.tableView.reloadData()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
//            self.tableView.mj_header.endRefreshing()
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
        api.getEmployerJobs(params as [String : AnyObject]) { response in
            switch response {
            case .success:
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
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MyJobsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyJobsCell", for: indexPath) as! JobCell

        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type.account == .employee || type == (.employer, .request){
            performSegue(withIdentifier: "ShowMyJobDetailsSegue", sender: self)
        } else if type.account == .employer && type.jobs != .done {
            performSegue(withIdentifier: "ShowMyJobMemberEditSegue", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (type.account == .employer && type.jobs == .request)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "删除", handler: { (_, indexPath) in
            let row = indexPath.row
            let id = self.jobsData[row]["ptID"].intValue
            self.api.deleteAJob(["access_token": API.token! as AnyObject, "ptID": id as AnyObject]) { response in
                switch response {
                case .success:
                    let res = JSON(data: response.value!)
                    if res["status"] == "success" {
                        self.jobsData.remove(at: row)
                        self.tableView.reloadData()
                    } else if res["status"] == "failure" {
                        print("failure")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        })
        
        return [deleteAction]
    }
    
}
