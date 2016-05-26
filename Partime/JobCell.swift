//
//  JobsTableViewCell.swift
//  Partime
//
//  Created by ShinCurry on 16/1/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD


class JobCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialStyle()
        
    }
    
    
    let api = API.shared
    var id: (job: Int, request: Int)?
    var status: Int?
    var superController: MyJobsTableViewController?
    // MARK: - View Properties
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var salaryTypeImage: UIImageView!
    @IBOutlet weak var salaryTypeLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel?
    @IBOutlet weak var jobButton: UIButton?
    
    @IBAction func cancelJob(sender: UIButton) {
        let alertController = UIAlertController(title: "取消申请工作", message: "确定要取消申请这个工作吗？", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "确定", style: .Default) { (action) in
            let params: [String: AnyObject] = ["access_token": API.token!,
                                               "requestID": self.id!.request]
            MBProgressHUD.showHUDAddedTo(self.superController!.view, animated: true)
            self.api.cancelAJobRequest(params) { response in
                switch response {
                case .Success:
                    let res = JSON(data: response.value!)
                    if res["status"] == "success" {
                        if let controller = self.superController {
                            controller.getEmployeeJobs()
                            let alertController = UIAlertController(title: "成功", message: "成功撤销兼职工作申请", preferredStyle: .Alert)
                            let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: { action in
                                MBProgressHUD.hideHUDForView(self.superController!.view, animated: true)
                            })
                            alertController.addAction(OKAction)
                            controller.presentViewController(alertController, animated: true, completion: nil)
                        }
                    } else if res["status"] == "failure" {
                        print("failure")
                    }
                case .Failure(let error):
                    print(error)
                }
                MBProgressHUD.hideHUDForView(self.superController!.view, animated: true)
                
            }
        }
        alertController.addAction(OKAction)
        superController!.presentViewController(alertController, animated: true, completion: nil)
    }
    @IBAction func rateJob(sender: UIButton) {
        print("rate")
    }
    @IBAction func startAJob(sender: UIButton) {
        let alertController = UIAlertController(title: "开始报名", message: "确定要开启报名吗？", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "确定", style: .Default) { (action) in
            MBProgressHUD.showHUDAddedTo(self.superController!.view, animated: true)
            self.api.startAJob(["access_token": API.token!, "ptID": "\(self.id!.job)"]) { response in
                switch response {
                case .Success:
                    let res = JSON(data: response.value!)
                    if res["status"].stringValue == "success" {
                        if let controller = self.superController {
                            let alertController = UIAlertController(title: "成功", message: "成功开始报名", preferredStyle: .Alert)
                            let OKAction = UIAlertAction(title: "完成", style: .Default, handler: { action in
                                controller.getEmployerJobs()
                                MBProgressHUD.hideHUDForView(self.superController!.view, animated: true)
                            })
                            alertController.addAction(OKAction)
                            self.superController!.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
                case .Failure(let error):
                    print(error)
                }
                MBProgressHUD.hideHUDForView(self.superController!.view, animated: true)
            }
        }
        alertController.addAction(OKAction)
        superController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    var type: (account: AccountType, jobs: MyJobsType) = (.None, .None) {
        didSet {
            if type.account == .Employee {
                switch type.jobs {
                case .Request:
                    jobButton?.setTitle("我要撤销", forState: .Normal)
                    jobButton?.addTarget(self, action: #selector(cancelJob), forControlEvents: .TouchUpInside)
                case .Hire:
                    jobButton?.setTitle("已录用", forState: .Normal)
                case .Working:
                    jobButton?.setTitle("等待支付", forState: .Normal)
                case .Rate:
                    jobButton?.setTitle("我要评价", forState: .Normal)
                    jobButton?.addTarget(self, action: #selector(rateJob), forControlEvents: .TouchUpInside)
                case .Done:
                    jobButton?.setTitle("评价完成", forState: .Normal)
                default:
                    jobButton?.titleLabel?.text = ""
                }
            } else if type.account == .Employer {
                switch type.jobs {
                case .Request:
                    //未发布
                    if status! == 22 {
                        jobButton?.setTitle("开始报名", forState: .Normal)
                        jobButton?.addTarget(self, action: #selector(startAJob), forControlEvents: .TouchUpInside)
                    } else if status! == 23 {
                        jobButton?.setTitle("已发布", forState: .Normal)
                    } else {
                        jobButton?.setTitle("", forState: .Normal)
                    }
                case .Hire:
                    fallthrough
                case .Working:
                    jobButton?.setTitle("", forState: .Normal)
                    jobButton?.enabled = false
                default:
                    break
                }
            }
        }
    }
}

extension JobCell {
    private func initialStyle() {
        locationImage.tintColor = Theme.mainColor
        timeImage.tintColor = Theme.mainColor
        salaryTypeImage.tintColor = Theme.mainColor
        
        salaryLabel?.tintColor = Theme.mainColor
        
        logoImage.clipsToBounds = true
        logoImage.layer.cornerRadius = logoImage.frame.size.width / 2
        separatorInset.left = 8 + logoImage.frame.size.width + 8
    }

}
