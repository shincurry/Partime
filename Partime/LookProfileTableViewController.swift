//
//  LookProfileTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/5/25.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class LookProfileTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
    
    
    var id: (user: String, job: String)? {
        didSet {
            api.getEmployeeProfile(["userID": self.id!.user]) { response in
                switch response {
                case .Success:
                    let res = JSON(data: response.value!)
                    print(res)
                    if res["status"] == "success" {
                        self.setInfo(res["result"])
                    } else if res["status"] == "failure" {
                        print("failure")
                    }
                case .Failure(let error):
                    print(error)
                }
            }
        }
    }
    
    let api = API.shared
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileGenderLabel: UILabel!
    @IBOutlet weak var profileBirthdayLabel: UILabel!
    @IBOutlet weak var profileLocationLabel: UILabel!
    @IBOutlet weak var profileSchoolLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    @IBOutlet weak var profileQQLabel: UILabel!
    @IBOutlet weak var profileTelephoneLabel: UILabel!
    @IBOutlet weak var profileIntroduction: UITextView!
    
    @IBAction func accept(sender: UIButton) {
        let params: [String: AnyObject] = ["access_token": API.token!,
                                           "ptID": id!.job,
                                           "userID": id!.user]
        self.api.dealRequest(params) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                if res["status"] == "success" {
                    self.performSegueWithIdentifier("UnwindLookProfileToMemberEditing", sender: self)
                } else if res["status"] == "failure" {
                    print("failure")
                }
            case .Failure(let error):
                print(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
        
        
    }
    
    @IBAction func refuse(sender: UIButton) {
    }
    
    func setInfo(data: JSON) {
        print(data)
        if let imgUrl = data["protrait"].string {
            profileImageView.sd_setImageWithURL(api.getImageUrl(imgUrl))
        }
        profileNameLabel.text = data["realname"].stringValue
        profileGenderLabel.text = data["gender"].stringValue
        profileBirthdayLabel.text = data["birthday"].stringValue
        profileTelephoneLabel.text = data["phone"].stringValue
        
//        profileLocationLabel.text =
        
        if let text = data["school"].string {
            profileSchoolLabel.text = text
        }
        if let text = data["introduction"].string {
            profileIntroduction.text = text
        }
        if let text = data["qq"].string {
            profileQQLabel.text = text
        }
        if let text = data["email"].string {
            profileEmailLabel.text = text
        }
        
        
        
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
//        switch (indexPath.section, indexPath.row) {
//        case (0, 2):
//            fallthrough
//        case (0, 3):
//            fallthrough
//        case (0, 4):
//            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
//        default:
//            break
//        }
//        return cell
//    }
}
