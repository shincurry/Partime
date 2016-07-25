//
//  JobPublishTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/5/3.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class PublishEditingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        salary = 0
        salaryTypeCode = 14
        
        contactLabel.text = defaults.objectForKey("ProfileRealname") as? String
        telephoneLabel.text = defaults.objectForKey("ProfileTelephone") as? String
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        clearsSelectionOnViewWillAppear NOT WORK on device
        if let selection = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selection, animated: true)
        }
    }
    
    let api = API.shared
    let defaults = NSUserDefaults(suiteName: "ProfileDefaults")!
    
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var jobTypeLabel: UILabel!
    
    @IBOutlet weak var beginDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var genderRequireLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var detailLocationLabel: UILabel!
    
    @IBOutlet weak var jobRequireTextView: UITextView!
    @IBOutlet weak var jobContentTextView: UITextView!
    
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    
    
    var memberCount: Int?
    var salary: Int?
    var jobTypeCode: Int?
    var salaryTypeCode: Int?
    var paymentTypeCode: Int?
    
    var genderRequireCode: Int?
    
    
    var provinceCode: String?
    var cityCode: String?
    var districtCode: String?
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            
            switch identifier {
            case "ShowDateFromSegue":
                let controller = segue.destinationViewController as! PublishDateTimePickerViewController
                controller.superLabel = beginDateLabel
                controller.type = .DateFrom
            case "ShowDateToSegue":
                let controller = segue.destinationViewController as! PublishDateTimePickerViewController
                controller.superLabel = endDateLabel
                controller.type = .DateTo
            case "ShowTimeFromSegue":
                let controller = segue.destinationViewController as! PublishDateTimePickerViewController
                controller.superLabel = beginTimeLabel
                controller.type = .TimeFrom
            case "ShowTimeToSegue":
                let controller = segue.destinationViewController as! PublishDateTimePickerViewController
                controller.superLabel = endTimeLabel
                controller.type = .TimeTo
            case "ShowTextEditingSegue":
                let indexPath = tableView.indexPathForSelectedRow!
                let cell = tableView.cellForRowAtIndexPath(indexPath)!
                let controller = segue.destinationViewController as! PublishEditingTextViewController
                controller.name = cell.textLabel!.text
                controller.detailsName = cell.detailTextLabel!.text
                controller.superLabel = cell.detailTextLabel
                
            case "ShowGenderRequireSegue":
                let controller = segue.destinationViewController as! PublishGeneralPickerViewController
                controller.superLabel = genderRequireLabel
                controller.superController = self
                controller.type = .GenderRequire
            case "ShowLocationSegue":
                let controller = segue.destinationViewController as! PublishGeneralPickerViewController
                controller.superLabel = locationLabel
                controller.superController = self
                controller.type = .Location
            case "ShowJobTypeSegue":
                let controller = segue.destinationViewController as! PublishGeneralPickerViewController
                controller.superLabel = jobTypeLabel
                controller.superController = self
                controller.type = .JobType
            case "ShowPaymentTypeSegue":
                let controller = segue.destinationViewController as! PublishGeneralPickerViewController
                controller.superLabel = paymentTypeLabel
                controller.superController = self
                controller.type = .PaymentType
            case "ShowSalarySegue":
                let controller = segue.destinationViewController as! PublishSalaryViewController
                controller.superLabel = salaryLabel
                controller.superController = self
            case "UnwindPublishJobToProfileSegue":
                let controller = segue.destinationViewController as! MyJobsTableViewController
                controller.getEmployerJobs()
            default:
                break
            }
            
        }
    }
}

extension PublishEditingTableViewController {

    @IBAction func finishEditing(sender: UIBarButtonItem) {
        if !jobNameLabel.text!.isEmpty
        && !jobTypeLabel.text!.isEmpty
        && !contactLabel.text!.isEmpty
        && !telephoneLabel.text!.isEmpty {
            let sheet = UIAlertController(title: "完成", message: "发布兼职工作", preferredStyle: .ActionSheet)
            let saveJobAction = UIAlertAction(title: "保存这个工作", style: .Default, handler: { _ in
                self.saveJob(andPublish: false)
            })
            let saveAndPublishJobAction = UIAlertAction(title: "保存工作并直接发布", style: .Default, handler: { _ in
                self.saveJob(andPublish: true)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            
            sheet.addAction(saveJobAction)
            sheet.addAction(saveAndPublishJobAction)
            sheet.addAction(cancelAction)
            self.presentViewController(sheet, animated: true, completion: nil)
            
            
            
            
        } else {
            let alertTitle = "缺失相关内容"
            let alertMessage = "请完善需要填写的内容"
            
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "知道了", style: .Default, handler: nil)
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    private func saveJob(andPublish doPublish: Bool) {
        
        var params: [String: AnyObject] = ["access_token": API.token!,
                                           "title": jobNameLabel.text!,
                                           "type": jobTypeCode!,
                                           "contactName": contactLabel.text!,
                                           "contactPhone": telephoneLabel.text!
        ]
        
        if doPublish {
            params["directPost"] = 1
        }
        
        if let text = beginDateLabel.text {
            params["dateBegin"] = text
        }
        if let text = endDateLabel.text {
            params["dateEnd"] = text
        }
        if let text = beginTimeLabel.text {
            params["timeBegin"] = text
        }
        if let text = endTimeLabel.text {
            params["timeEnd"] = text
        } else {
            
        }
        if let sal = salary {
            params["salary"] = sal
        }
        if let code = salaryTypeCode {
            params["salaryType"] = code
        }
        
        if let code = paymentTypeCode {
            params["salaryWhen"] = code
        }
        if let count = Int(memberCountLabel.text!) {
            params["amount"] = count
        }
        if let code = genderRequireCode {
            params["genderNeed"] = code
        }
        
        if let code = districtCode {
            params["districtid"] = code
        }
        
        if let text = jobRequireTextView.text {
            params["description"] = text
        }
        if let text = jobContentTextView.text {
            params["detailAndDemand"] = text
        }
        
        
        print(params)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        api.postAJob(params) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                print(res)
                if res["status"].stringValue == "success" {
                    let alertController = UIAlertController(title: "成功", message: "发布兼职成功", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "完成", style: .Default, handler: { _ in
                        self.performSegueWithIdentifier("UnwindPublishJobToProfileSegue", sender: self)
                    
                    })
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            case .Failure(let error):
                print(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    private func checkInfo() -> Bool {
        if jobNameLabel.text!.isEmpty || jobTypeLabel.text!.isEmpty {
            return false
        }
        
        return true
    }
}

extension PublishEditingTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):// 职位名称
            showTextEditingView()
        case (0, 1):// 职位类型
            break
        case (0, 2):// 开始工作日期
            break
        case (0, 3):// 结束工作日期
            break
        case (0, 4):// 开始工作日期
            break
        case (0, 5):// 结束工作日期
            break
        case (0, 6):// 工资待遇
            break
//            showTextEditingView()
        // --------
        case (1, 0):// 结算方式
            break
        case (1, 1):// 招聘人数
            showTextEditingView()
        // --------
        case (2, 0):// 性别要求
            break
        case (2, 1):// 工作地址
            break
        case (2, 2):// 详细地址
            showTextEditingView()
        // --------
        case (3, 1):// 岗位要求
            break
        // --------
        case (4, 1):// 工作内容
            break
        // --------
        case (5, 0):// 联系人
            showTextEditingView()
        case (5, 1):// 联系电话
            showTextEditingView()
        default:
            break
        }
    }
    
    private func showTextEditingView() {
        performSegueWithIdentifier("ShowTextEditingSegue", sender: self)
    }
}
