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
    
    @IBAction func cancelJob(_ sender: UIButton) {
        let alertController = UIAlertController(title: "取消申请工作", message: "确定要取消申请这个工作吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "确定", style: .default) { (action) in
            let params: [String: AnyObject] = ["access_token": API.token! as AnyObject,
                                               "requestID": self.id!.request as AnyObject]
            MBProgressHUD.showAdded(to: self.superController!.view, animated: true)
            self.api.cancelAJobRequest(params) { response in
                switch response {
                case .success:
                    let res = JSON(data: response.value!)
                    if res["status"] == "success" {
                        if let controller = self.superController {
                            controller.getEmployeeJobs()
                            let alertController = UIAlertController(title: "成功", message: "成功撤销兼职工作申请", preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                                MBProgressHUD.hide(for: self.superController!.view, animated: true)
                            })
                            alertController.addAction(OKAction)
                            controller.present(alertController, animated: true, completion: nil)
                        }
                    } else if res["status"] == "failure" {
                        print("failure")
                    }
                case .failure(let error):
                    print(error)
                }
                MBProgressHUD.hide(for: self.superController!.view, animated: true)
                
            }
        }
        alertController.addAction(OKAction)
        superController!.present(alertController, animated: true, completion: nil)
    }
    @IBAction func rateJob(_ sender: UIButton) {
        print("rate")
    }
    @IBAction func startAJob(_ sender: UIButton) {
        let alertController = UIAlertController(title: "开始报名", message: "确定要开启报名吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "确定", style: .default) { (action) in
            MBProgressHUD.showAdded(to: self.superController!.view, animated: true)
            self.api.startAJob(["access_token": API.token! as AnyObject, "ptID": "\(self.id!.job)" as AnyObject]) { response in
                switch response {
                case .success:
                    let res = JSON(data: response.value!)
                    if res["status"].stringValue == "success" {
                        if let controller = self.superController {
                            let alertController = UIAlertController(title: "成功", message: "成功开始报名", preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "完成", style: .default, handler: { action in
                                controller.getEmployerJobs()
                                MBProgressHUD.hide(for: self.superController!.view, animated: true)
                            })
                            alertController.addAction(OKAction)
                            self.superController!.present(alertController, animated: true, completion: nil)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                MBProgressHUD.hide(for: self.superController!.view, animated: true)
            }
        }
        alertController.addAction(OKAction)
        superController!.present(alertController, animated: true, completion: nil)
    }
    
    var type: (account: AccountType, jobs: MyJobsType) = (.none, .none) {
        didSet {
            if type.account == .employee {
                switch type.jobs {
                case .request:
                    jobButton?.setTitle("我要撤销", for: UIControlState())
                    jobButton?.addTarget(self, action: #selector(cancelJob), for: .touchUpInside)
                case .hire:
                    jobButton?.setTitle("已录用", for: UIControlState())
                case .working:
                    jobButton?.setTitle("等待支付", for: UIControlState())
                case .rate:
                    jobButton?.setTitle("我要评价", for: UIControlState())
                    jobButton?.addTarget(self, action: #selector(rateJob), for: .touchUpInside)
                case .done:
                    jobButton?.setTitle("评价完成", for: UIControlState())
                default:
                    jobButton?.titleLabel?.text = ""
                }
            } else if type.account == .employer {
                switch type.jobs {
                case .request:
                    //未发布
                    if status! == 22 {
                        jobButton?.setTitle("开始报名", for: UIControlState())
                        jobButton?.addTarget(self, action: #selector(startAJob), for: .touchUpInside)
                    } else if status! == 23 {
                        jobButton?.setTitle("已发布", for: UIControlState())
                    } else {
                        jobButton?.setTitle("", for: UIControlState())
                    }
                case .hire:
                    fallthrough
                case .working:
                    jobButton?.setTitle("", for: UIControlState())
                    jobButton?.isEnabled = false
                default:
                    break
                }
            }
        }
    }
}

extension JobCell {
    fileprivate func initialStyle() {
        locationImage.tintColor = Theme.mainColor
        timeImage.tintColor = Theme.mainColor
        salaryTypeImage.tintColor = Theme.mainColor
        
        salaryLabel?.tintColor = Theme.mainColor
        
        logoImage.clipsToBounds = true
        logoImage.layer.cornerRadius = logoImage.frame.size.width / 2
        separatorInset.left = 8 + logoImage.frame.size.width + 8
    }

}
