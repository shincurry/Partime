//
//  JobsTableViewCell.swift
//  Partime
//
//  Created by ShinCurry on 16/1/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import SwiftyJSON


class JobCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialStyle()
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    let api = API.shared
    var id: Int? {
        didSet {
            jobButton?.enabled = true
        }
    }
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
    
    @IBAction func cancelJob(sender: AnyObject) {
        
        let params: [String: AnyObject] = ["access_token": API.token!,
                      "requestID": id!]
        api.cancelAJobRequest(params) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                if res["status"] == "success" {
                    if let controller = self.superController {
                        controller.type = .Request
                        let alertController = UIAlertController(title: "成功", message: "成功撤销兼职工作申请", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: nil)
                        alertController.addAction(OKAction)
                        controller.presentViewController(alertController, animated: true, completion: nil)
                    }
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .Failure(let error):
                print(error)
            }
            
        }
    }
    @IBAction func rateJob(sender: AnyObject) {
        print("rate")
    }
    
    var type: MyJobsType = .None {
        didSet {
            switch type {
            case .Request:
                jobButton?.titleLabel?.text = "我要撤销"
                jobButton?.addTarget(self, action: #selector(cancelJob), forControlEvents: .TouchUpInside)
            case .Hire:
                jobButton?.titleLabel?.text = "已录用"
            case .Working:
                jobButton?.titleLabel?.text = "等待支付"
            case .Rate:
                jobButton?.titleLabel?.text = "我要评价"
                jobButton?.addTarget(self, action: #selector(rateJob), forControlEvents: .TouchUpInside)
            case .Done:
                jobButton?.titleLabel?.text = "评价完成"
            default:
                 jobButton?.titleLabel?.text = ""
            }
        }
    }
}

extension JobCell {
    private func initialStyle() {
        locationImage.tintColor = Theme.mainColor
        timeImage.tintColor = Theme.mainColor
        salaryTypeImage.tintColor = Theme.mainColor
        
        logoImage.clipsToBounds = true
        print(logoImage.frame.size.width)
        logoImage.layer.cornerRadius = logoImage.frame.size.width / 2
        print(logoImage.layer.cornerRadius)
        separatorInset.left = 8 + logoImage.frame.size.width + 8
    }

}
