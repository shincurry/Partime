//
//  JobDetailsTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/2/27.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import MJRefresh

enum JobStatus {
    case None
}

class JobDetailsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = API.token {
        } else {
            joinButton.enabled = false
        }
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
    }
    
    override func viewDidLayoutSubviews() {
        initialViewStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Properties
    
    @IBOutlet weak var navigatorTitle: UINavigationItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var jobTypeLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var genderRequireLabel: UILabel!
    
    
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateScoreLabel: UILabel!
    
    
    @IBOutlet weak var workRequireTextView: UITextView! {
        didSet {
//            workRequireConstraint.constant = workRequireTextView.fullSize().height
        }
    }
    @IBOutlet weak var workContentTextView: UITextView! {
        didSet {
//            workContentConstraint.constant = workContentTextView.fullSize().height
        }
    }
    
    @IBOutlet weak var workDateLabel: UILabel!
    
    @IBOutlet weak var workTimeLabel: UILabel!
    
    
    @IBOutlet weak var companyLogoImage: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var contactNameImage: UIImageView!
    @IBOutlet weak var contactNameButton: UIButton!
    
    @IBOutlet weak var contactTelephoneImage: UIImageView!
    @IBOutlet weak var contactTelephoneButton: UIButton!
    
    @IBOutlet weak var contactEmailImage: UIImageView!
    
    @IBOutlet weak var contactEmailButton: UIButton!
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var mapLabel: UILabel!
    

    @IBOutlet weak var workRequireConstraint: NSLayoutConstraint!
    @IBOutlet weak var workContentConstraint: NSLayoutConstraint!
    let api = API.shared
    
    var id: Int? {
        didSet {
            loadData()
        }
    }
    var location: (Double, Double)?
    var mapHidden = true
    
    @IBOutlet weak var joinButton: UIButton!
    @IBAction func join(sender: UIButton) {
        if let id = self.id {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            api.requestAJob(["access_token": API.token!, "ptID": id]) { result in
                switch result {
                case .Success:
                    let data = JSON(data: result.value!)
                    print(data)
                    if data["status"].stringValue == "success" {
                        let alertController = UIAlertController(title: "兼职报名", message: "兼职报名成功", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "完成", style: .Default, handler: nil)
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true) {}
                    } else if data["status"] == "failure" {
                        var message = ""
                        if data["code"].intValue == 422 {
                            message = "自己的兼职不能报名"
                        } else if data["code"].intValue == 409 {
                            message = "这个兼职已经报名"
                        } else if data["code"].intValue == 410 {
                            message = "兼职已超过开始日期，不能报名"
                        } else if data["code"].intValue == 416 {
                            message = "和已报名的（申请中或已通过）时间冲突"
                        } else if data["code"].intValue == 406 {
                            message = "未知错误"
                        }

                        let alertController = UIAlertController(title: "报名失败", message: message, preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "完成", style: .Default, handler: nil)
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true) {}
                    }
                case .Failure(let error):
                    print(error)
                }
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        }
        
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch identifier {
            case "ShowMapSegue":
                if let _ = location {
                    return true
                }
            default:
                break
            }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            
            switch identifier {
            case "ShowMapSegue":
                let controller = segue.destinationViewController as! MapViewController
                controller.location = location
                
            default:
                break
            }
            
        }
    }
    
}

// MARK: - Table View Delegate and DataSource
extension JobDetailsTableViewController {
    func loadData() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        api.getJobDetails(id!) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                if res["status"] == "success" {
                    print(res["result"])
                    self.setInfo(res["result"])
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
    
    func setInfo(data: JSON) {
        navigatorTitle.title = data["title"].stringValue
        titleLabel.text = data["title"].stringValue
        
        
        locationLabel.text = data["district"].stringValue
        timeLabel.text = data["dateBegin"].stringValue
        
        
        rateLabel.text = RateStar(score: 0).getStars()
        rateScoreLabel.text = "0"
        
        
        jobTypeLabel.text = data["type"].stringValue
        memberCountLabel.text = "\(data["amount"].intValue)"
        salaryLabel.text = data["salary"].stringValue + "元" + "/" + data["salarytype"].stringValue
        genderRequireLabel.text = data["genderneed"].stringValue
        
        
        if !data["dateBegin"].stringValue.isEmpty && !data["dateEnd"].stringValue.isEmpty {
            workDateLabel.text = "\(data["dateBegin"].stringValue) ~ \(data["dateEnd"].stringValue)"
        }
        if !data["timeBegin"].stringValue.isEmpty && !data["timeEnd"].stringValue.isEmpty {
            workTimeLabel.text = data["timeBegin"].stringValue + " ~ " + data["timeEnd"].stringValue
        }
        
        workRequireTextView.text = data["detailanddemand"].stringValue
        workContentTextView.text = data["description"].stringValue
        
        contactNameButton.setTitle(data["contactname"].stringValue, forState: .Normal)
        contactTelephoneButton.setTitle(data["contactphone"].stringValue, forState: .Normal)
        
        if let address = data["address"].string {
            mapLabel.text = address
            if let latitude = data["latitude"].double {
                if let longitude = data["longitude"].double {
                    location = (latitude, longitude)
                    mapHidden = false
                }
            }
        }
    }

//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
//        if indexPath.section == 0 && indexPath.row == 0 {
//        
//            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
//        }
//        return cell
//    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 12
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cellHeight = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
//        if indexPath.section == 1 && indexPath.row == 2 {
//            let originalHeight = workRequireTextView.frame.height
//            let fullHeight = workRequireTextView.fullSize().height
//            cellHeight += fullHeight - originalHeight
//        } else if indexPath.section == 1 && indexPath.row == 3 {
//            let originalHeight = workContentTextView.frame.height
//            let fullHeight = workContentTextView.fullSize().height
//            cellHeight += fullHeight - originalHeight
        if indexPath.section == 3 && indexPath.row == 0 {
            if mapHidden {
                cellHeight = 0
            }
        } else if indexPath.section == 4 && indexPath.row == 1 {
            if mapHidden {
                cellHeight = 0
            }
        }
        
        return cellHeight

    }
}

// MARK: - View Style
extension JobDetailsTableViewController {
    private func initialViewStyle() {
        tableView.backgroundColor = Theme.backgroundColor
        companyLogoImage.clipsToBounds = true
        companyLogoImage.layer.cornerRadius = companyLogoImage.frame.size.width / 2
        locationImage.tintColor = Theme.mainColor
        timeImage.tintColor = Theme.mainColor
        contactNameImage.tintColor = Theme.mainColor
        contactTelephoneImage.tintColor = Theme.mainColor
        contactEmailImage.tintColor = Theme.mainColor
        mapImage.tintColor = Theme.mainColor
    }
}

// MARK: - Contact Quick Launch
extension JobDetailsTableViewController {
    @IBAction func calling(sender: UIButton) {
        let phoneNumber = sender.currentTitle!
        let url = NSURL(string: "tel://\(phoneNumber)")!
        let alertTitle = "拨打电话"
        let alertMessage = "你确定要拨打 \(phoneNumber) 这个电话号码吗？"
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "确定", style: .Default) { (action) in
            UIApplication.sharedApplication().openURL(url)
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func mailing(sender: UIButton) {
        let email = sender.currentTitle!
        let url = NSURL(string: "mailto://\(email)")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func qq(sender: UIButton) {
        let qq = sender.currentTitle!
        let url = NSURL(string: "mqq://\(qq)")!
        UIApplication.sharedApplication().openURL(url)
        
    }
}

extension UITextView {
    func fullSize() -> CGSize {
        return self.sizeThatFits(self.contentSize)
    }
}
