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
        
        contactLabel.text = defaults.object(forKey: "ProfileRealname") as? String
        telephoneLabel.text = defaults.object(forKey: "ProfileTelephone") as? String
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        clearsSelectionOnViewWillAppear NOT WORK on device
        if let selection = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selection, animated: true)
        }
    }
    
    let api = API.shared
    let defaults = UserDefaults(suiteName: "ProfileDefaults")!
    
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            
            switch identifier {
            case "ShowDateFromSegue":
                let controller = segue.destination as! PublishDateTimePickerViewController
                controller.superLabel = beginDateLabel
                controller.type = .dateFrom
            case "ShowDateToSegue":
                let controller = segue.destination as! PublishDateTimePickerViewController
                controller.superLabel = endDateLabel
                controller.type = .dateTo
            case "ShowTimeFromSegue":
                let controller = segue.destination as! PublishDateTimePickerViewController
                controller.superLabel = beginTimeLabel
                controller.type = .timeFrom
            case "ShowTimeToSegue":
                let controller = segue.destination as! PublishDateTimePickerViewController
                controller.superLabel = endTimeLabel
                controller.type = .timeTo
            case "ShowTextEditingSegue":
                let indexPath = tableView.indexPathForSelectedRow!
                let cell = tableView.cellForRow(at: indexPath)!
                let controller = segue.destination as! PublishEditingTextViewController
                controller.name = cell.textLabel!.text
                controller.detailsName = cell.detailTextLabel!.text
                controller.superLabel = cell.detailTextLabel
                
            case "ShowGenderRequireSegue":
                let controller = segue.destination as! PublishGeneralPickerViewController
                controller.superLabel = genderRequireLabel
                controller.superController = self
                controller.type = .genderRequire
            case "ShowLocationSegue":
                let controller = segue.destination as! PublishGeneralPickerViewController
                controller.superLabel = locationLabel
                controller.superController = self
                controller.type = .location
            case "ShowJobTypeSegue":
                let controller = segue.destination as! PublishGeneralPickerViewController
                controller.superLabel = jobTypeLabel
                controller.superController = self
                controller.type = .jobType
            case "ShowPaymentTypeSegue":
                let controller = segue.destination as! PublishGeneralPickerViewController
                controller.superLabel = paymentTypeLabel
                controller.superController = self
                controller.type = .paymentType
            case "ShowSalarySegue":
                let controller = segue.destination as! PublishSalaryViewController
                controller.superLabel = salaryLabel
                controller.superController = self
            case "UnwindPublishJobToProfileSegue":
                let controller = segue.destination as! MyJobsTableViewController
                controller.getEmployerJobs()
            default:
                break
            }
            
        }
    }
}

extension PublishEditingTableViewController {

    @IBAction func finishEditing(_ sender: UIBarButtonItem) {
        if !jobNameLabel.text!.isEmpty
        && !jobTypeLabel.text!.isEmpty
        && !contactLabel.text!.isEmpty
        && !telephoneLabel.text!.isEmpty {
            let sheet = UIAlertController(title: "完成", message: "发布兼职工作", preferredStyle: .actionSheet)
            let saveJobAction = UIAlertAction(title: "保存这个工作", style: .default, handler: { _ in
                self.saveJob(andPublish: false)
            })
            let saveAndPublishJobAction = UIAlertAction(title: "保存工作并直接发布", style: .default, handler: { _ in
                self.saveJob(andPublish: true)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            sheet.addAction(saveJobAction)
            sheet.addAction(saveAndPublishJobAction)
            sheet.addAction(cancelAction)
            self.present(sheet, animated: true, completion: nil)
            
            
            
            
        } else {
            let alertTitle = "缺失相关内容"
            let alertMessage = "请完善需要填写的内容"
            
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "知道了", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    fileprivate func saveJob(andPublish doPublish: Bool) {
        
        var params: [String: AnyObject] = ["access_token": API.token! as AnyObject,
                                           "title": jobNameLabel.text! as AnyObject,
                                           "type": jobTypeCode! as AnyObject,
                                           "contactName": contactLabel.text! as AnyObject,
                                           "contactPhone": telephoneLabel.text! as AnyObject
        ]
        
        if doPublish {
            params["directPost"] = 1 as AnyObject?
        }
        
        if let text = beginDateLabel.text {
            params["dateBegin"] = text as AnyObject?
        }
        if let text = endDateLabel.text {
            params["dateEnd"] = text as AnyObject?
        }
        if let text = beginTimeLabel.text {
            params["timeBegin"] = text as AnyObject?
        }
        if let text = endTimeLabel.text {
            params["timeEnd"] = text as AnyObject?
        } else {
            
        }
        if let sal = salary {
            params["salary"] = sal as AnyObject?
        }
        if let code = salaryTypeCode {
            params["salaryType"] = code as AnyObject?
        }
        
        if let code = paymentTypeCode {
            params["salaryWhen"] = code as AnyObject?
        }
        if let count = Int(memberCountLabel.text!) {
            params["amount"] = count as AnyObject?
        }
        if let code = genderRequireCode {
            params["genderNeed"] = code as AnyObject?
        }
        
        if let code = districtCode {
            params["districtid"] = code as AnyObject?
        }
        
        if let text = jobRequireTextView.text {
            params["description"] = text as AnyObject?
        }
        if let text = jobContentTextView.text {
            params["detailAndDemand"] = text as AnyObject?
        }
        
        
        print(params)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        api.postAJob(params) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                print(res)
                if res["status"].stringValue == "success" {
                    let alertController = UIAlertController(title: "成功", message: "发布兼职成功", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "完成", style: .default, handler: { _ in
                        self.performSegue(withIdentifier: "UnwindPublishJobToProfileSegue", sender: self)
                    
                    })
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    fileprivate func checkInfo() -> Bool {
        if jobNameLabel.text!.isEmpty || jobTypeLabel.text!.isEmpty {
            return false
        }
        
        return true
    }
}

extension PublishEditingTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    fileprivate func showTextEditingView() {
        performSegue(withIdentifier: "ShowTextEditingSegue", sender: self)
    }
}
