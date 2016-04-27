//
//  EditingTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/4/25.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class EditingProfileTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileInfo()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let defaults = NSUserDefaults(suiteName: "ProfileDefaults")!
    let api = API.shared
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var statureLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    var locationCode: String? = "500100"
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var qqLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var introductionTextView: UITextView!
    @IBOutlet weak var workExperienceTextView: UITextView!

    func getProfileInfo() {
        nameLabel.text = defaults.objectForKey("ProfileRealname") as? String
        genderLabel.text = defaults.objectForKey("ProfileGender") as? String
        birthdayLabel.text = defaults.objectForKey("ProfileBirthday") as? String
        statureLabel.text = "\(defaults.integerForKey("ProfileStature"))"
        locationCode = defaults.objectForKey("ProfileCityID") as? String
        qqLabel.text = defaults.objectForKey("ProfileQQ") as? String
        emailLabel.text = defaults.objectForKey("ProfileEmail") as? String
        schoolLabel.text = defaults.objectForKey("ProfileSchool") as? String
        if let intro = defaults.objectForKey("ProfileIntroduction") as? String {
            introductionTextView.text = intro
        }
        if let exp = defaults.objectForKey("ProfileWorkExperience") as? String {
            workExperienceTextView.text = exp
        }
        if let uri = defaults.objectForKey("ProfileAvatar") as? String {
            print("image uri : \(uri)")
            avatarImageView.sd_setImageWithURL(api.getImageUrl(uri), placeholderImage: UIImage(named: "DefaultProfile"), options: .RefreshCached)
        }
        for key in defaults.dictionaryRepresentation().keys {
            print("\(defaults.objectForKey(key) as? String)")
        }
    }
    func setProfileInfo() {
        defaults.setObject(nameLabel.text, forKey: "ProfileRealname")
        defaults.setObject(genderLabel.text, forKey: "ProfileGender")
        defaults.setObject(birthdayLabel.text, forKey: "ProfileBirthday")
        if let stature = statureLabel.text {
            defaults.setInteger(Int(stature)!, forKey: "ProfileStature")
        } else {
            defaults.setInteger(0, forKey: "ProfileStature")
        }
        
        defaults.setObject(locationCode, forKey: "ProfileCityID")
        defaults.setObject(qqLabel.text, forKey: "ProfileQQ")
        defaults.setObject(emailLabel.text, forKey: "ProfileEmail")
        defaults.setObject(schoolLabel.text, forKey: "ProfileSchool")
        defaults.setObject(introductionTextView.text, forKey: "ProfileIntroduction")
        defaults.setObject(workExperienceTextView.text, forKey: "ProfileWorkExperience")
        defaults.synchronize()
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        if nameLabel.text!.isEmpty || genderLabel.text!.isEmpty || birthdayLabel.text!.isEmpty || locationLabel.text!.isEmpty {
            print("empty")
            let alertTitle = "信息不完整"
            let alertMessage = "带星号的必须要填写噢"
            
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "知道了", style: .Default, handler: nil)
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }

        
        
        print(API.token!)
        var params: [String: String] =
            ["access_token"  : "\(API.token!)",
             "realname"      : "\(nameLabel.text!)",
             "gender"        : "\(genderLabel.text!)",
             "cityid"        : "110000",
             "birthday"      : "\(birthdayLabel.text!)"
            ]
        if let qq = qqLabel.text {
            params["qq"] = "\(qq)"
        }
        if let email = emailLabel.text {
            params["email"] = "\(email)"
        }
//        if let stature = statureLabel.text {
//            if let value = Int(stature) {
//                params["height"] = value
//            }
//        }
        
        
        if let school = schoolLabel.text {
            params["school"] = "\(school)"
        }
        if let intro = introductionTextView.text {
            params["introduction"] = "\(intro)"
        }
        if let exp = workExperienceTextView.text {
            params["workexperience"] = "\(exp)"
        }
    
        print("params")
        print(params)
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        api.updateProfile(params) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                if res["status"].stringValue == "success" {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.setProfileInfo()
                        self.performSegueWithIdentifier("UnwindEditingToProfileSegue", sender: self)
                } else if res["status"].stringValue == "failure" {
                    let alertTitle = "Error"
                    let alertMessage = res["error_description"].stringValue
                    
                    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            case .Failure(let error):
                print(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            
            switch identifier {
            case "ShowTextEditingSegue":
                let indexPath = tableView.indexPathForSelectedRow!
                let cell = tableView.cellForRowAtIndexPath(indexPath)!
                let controller = segue.destinationViewController as! EditingTextViewController
                controller.superLabel = cell.detailTextLabel
                controller.name = cell.textLabel!.text
                controller.detailsName = cell.detailTextLabel!.text
                
            case "ShowGenderPickerSegue":
                let indexPath = tableView.indexPathForSelectedRow!
                let cell = tableView.cellForRowAtIndexPath(indexPath)!
                let controller = segue.destinationViewController as! PickerViewController
                controller.superLabel = cell.detailTextLabel
                controller.type = .Some(.Gender)

            case "ShowLocationPickerSegue":
                let indexPath = tableView.indexPathForSelectedRow!
                let cell = tableView.cellForRowAtIndexPath(indexPath)!
                let controller = segue.destinationViewController as! PickerViewController
                controller.superLabel = cell.detailTextLabel
                controller.type = .Some(.Location)

            case "ShowDatePickerSegue":
                let indexPath = tableView.indexPathForSelectedRow!
                let cell = tableView.cellForRowAtIndexPath(indexPath)!
                let controller = segue.destinationViewController as! DatePickerViewController
                controller.superLabel = cell.detailTextLabel
                
                
            case "UnwindEditingToProfileSegue":
                let controller = segue.destinationViewController as! ProfileTableViewController
                controller.updateLoginStatus(refresh: true)
            default:
                break
            }
            
        }
    }
}

extension EditingProfileTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        switch (section, row) {
        case (0, 0):// 头像
            showImagePicker()
            break
        case (1, 0):// 姓名
            showEditingTextView()
        case (1, 1):// 性别
            break
        case (1, 2):// 身高
            showEditingTextView()
        case (1, 3):// 出生日期
            break
        // ---------------
        case (2, 0):// 所在地区
//            showLocationPicker()
            break
        case (2, 1):// 学校
            showEditingTextView()
        // ---------------
        case (3, 0):// 邮箱
            showEditingTextView()
        case (3, 1):// QQ
            showEditingTextView()
        case (3, 2):// 联系电话
            showEditingTextView()
        // ---------------  
        case (4, 1):// 个人简介
            break
        case (5, 1):// 工作经历
            break
        default:
            break
        }
        
       
    }
}

extension EditingProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showEditingTextView() {
         performSegueWithIdentifier("ShowTextEditingSegue", sender: self)
    }
    func showGenderPicker() {
        performSegueWithIdentifier("ShowGenderPickerSegue", sender: self)
    }
    func showLocationPicker() {
        performSegueWithIdentifier("ShowLocationPickerSegue", sender: self)
    }
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let imageData = UIImagePNGRepresentation(chosenImage)!
        let imageBase64String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        api.updateAvatar(["access_token": API.token!, "img": imageBase64String]) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                if res["status"].stringValue == "success" {
                    self.avatarImageView.image = chosenImage
                } else if res["status"].stringValue == "failure" {
                    let alertTitle = "Error"
                    let alertMessage = res["error_description"].stringValue
                    
                    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            case .Failure(let error):
                print(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
