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
        
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        clearsSelectionOnViewWillAppear NOT WORK on device
        if let selection = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selection, animated: true)
        }
    }
    
    let defaults = UserDefaults(suiteName: "ProfileDefaults")!
    let api = API.shared
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var statureLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var qqLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var introductionTextView: UITextView!
    @IBOutlet weak var workExperienceTextView: UITextView!
    
    var provinceCode: String?
    var cityCode: String?
    var districtCode: String?

    func getProfileInfo() {
        nameLabel.text = defaults.object(forKey: "ProfileRealname") as? String
        genderLabel.text = defaults.object(forKey: "ProfileGender") as? String
        birthdayLabel.text = defaults.object(forKey: "ProfileBirthday") as? String
        let stature = defaults.integer(forKey: "ProfileStature")
        if stature != 0 {
            statureLabel.text = "\(stature)"
        }
        
        provinceCode = defaults.object(forKey: "ProfileProvinceID") as? String
        cityCode = defaults.object(forKey: "ProfileCityID") as? String
        districtCode = defaults.object(forKey: "ProfileDistrictID") as? String
        locationLabel.text = defaults.object(forKey: "ProfileLocationName") as? String
        
        qqLabel.text = defaults.object(forKey: "ProfileQQ") as? String
        emailLabel.text = defaults.object(forKey: "ProfileEmail") as? String
        schoolLabel.text = defaults.object(forKey: "ProfileSchool") as? String
        if let intro = defaults.object(forKey: "ProfileIntroduction") as? String {
            introductionTextView.text = intro
        }
        if let exp = defaults.object(forKey: "ProfileWorkExperience") as? String {
            workExperienceTextView.text = exp
        }
        if let uri = defaults.object(forKey: "ProfileAvatar") as? String {
            print("image uri : \(uri)")
            avatarImageView.sd_setImage(with: api.getImageUrl(uri), placeholderImage: UIImage(named: "DefaultProfile"), options: .refreshCached)
        }
        for key in defaults.dictionaryRepresentation().keys {
            print("\(defaults.object(forKey: key) as? String)")
        }
    }
    func setProfileInfo() {
        defaults.set(nameLabel.text, forKey: "ProfileRealname")
        defaults.set(genderLabel.text, forKey: "ProfileGender")
        defaults.set(birthdayLabel.text, forKey: "ProfileBirthday")
        if let stature = statureLabel.text {
            if let value = Int(stature) {
                defaults.set(value, forKey: "ProfileStature")
            }
        } else {
            defaults.set(0, forKey: "ProfileStature")
        }
        print(defaults.integer(forKey: "ProfileStature"))
        defaults.set(provinceCode, forKey: "ProfileProvinceID")
        defaults.set(cityCode, forKey: "ProfileCityID")
        defaults.set(districtCode, forKey: "ProfileDistrictID")
        defaults.set(locationLabel.text, forKey: "ProfileLocationName")
        
        defaults.set(qqLabel.text, forKey: "ProfileQQ")
        defaults.set(emailLabel.text, forKey: "ProfileEmail")
        defaults.set(schoolLabel.text, forKey: "ProfileSchool")
        defaults.set(introductionTextView.text, forKey: "ProfileIntroduction")
        defaults.set(workExperienceTextView.text, forKey: "ProfileWorkExperience")
        defaults.synchronize()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if nameLabel.text!.isEmpty || genderLabel.text!.isEmpty || birthdayLabel.text!.isEmpty || locationLabel.text!.isEmpty {
            print("empty")
            let alertTitle = "信息不完整"
            let alertMessage = "带星号的必须要填写噢"
            
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "知道了", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }

        
        
        print(API.token!)
        var params: [String: AnyObject] =
            ["access_token"  : API.token! as AnyObject,
             "realname"      : nameLabel.text! as AnyObject,
             "gender"        : genderLabel.text! as AnyObject,
             "districtid"    : districtCode! as AnyObject,
             "birthday"      : birthdayLabel.text! as AnyObject
            ]
        if let qq = qqLabel.text {
            if !qq.isEmpty {
                params["qq"] = "\(qq)" as AnyObject?
            }
        }
        if let email = emailLabel.text {
            if !email.isEmpty {
                params["email"] = "\(email)" as AnyObject?
            }
        }
        if let stature = statureLabel.text {
            if let value = Int(stature) {
                params["height"] = value as AnyObject?
            }
        }
        
        
        if let school = schoolLabel.text {
            if !school.isEmpty {
                params["school"] = "\(school)" as AnyObject?
            }
        }
        if let intro = introductionTextView.text {
            if !intro.isEmpty {
                params["introduction"] = "\(intro)" as AnyObject?
            }
        }
        
        if let exp = workExperienceTextView.text {
            if !exp.isEmpty {
                params["workexperience"] = "\(exp)" as AnyObject?
            }
        }
    
        print(params)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        api.updateProfile(params) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                print(res)
                if res["status"].stringValue == "success" {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.setProfileInfo()
                    self.performSegue(withIdentifier: "UnwindEditingToProfileSegue", sender: self)
                } else if res["status"].stringValue == "failure" {
                    let alertTitle = "Error"
                    let alertMessage = res["error_description"].stringValue
                    
                    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            
            switch identifier {
            case "ShowTextEditingSegue":
                let indexPath = tableView.indexPathForSelectedRow!
                let cell = tableView.cellForRow(at: indexPath)!
                let controller = segue.destination as! EditingTextViewController
                controller.superLabel = cell.detailTextLabel
                controller.name = cell.textLabel!.text
                controller.detailsName = cell.detailTextLabel!.text
                
            case "ShowGenderPickerSegue":
                let indexPath = tableView.indexPathForSelectedRow!
                let cell = tableView.cellForRow(at: indexPath)!
                let controller = segue.destination as! PickerViewController
                controller.superLabel = cell.detailTextLabel
                controller.superController = self
                controller.type = .some(.gender)

            case "ShowLocationPickerSegue":
                let indexPath = tableView.indexPathForSelectedRow!
                let cell = tableView.cellForRow(at: indexPath)!
                let controller = segue.destination as! PickerViewController
                controller.superLabel = cell.detailTextLabel
                controller.superController = self
                controller.type = .some(.location)

            case "ShowDatePickerSegue":
                let indexPath = tableView.indexPathForSelectedRow!
                let cell = tableView.cellForRow(at: indexPath)!
                let controller = segue.destination as! DatePickerViewController
                controller.superLabel = cell.detailTextLabel
                
            case "UnwindEditingToProfileSegue":
                let controller = segue.destination as! ProfileTableViewController
                controller.updateLoginStatus()
            default:
                break
            }
            
        }
    }
}

extension EditingProfileTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
         performSegue(withIdentifier: "ShowTextEditingSegue", sender: self)
    }
    func showGenderPicker() {
        performSegue(withIdentifier: "ShowGenderPickerSegue", sender: self)
    }
    func showLocationPicker() {
        performSegue(withIdentifier: "ShowLocationPickerSegue", sender: self)
    }
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let imageData = UIImagePNGRepresentation(chosenImage)!
        let imageBase64String = imageData.base64EncodedString(options: .lineLength64Characters)
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        api.updateAvatar(["access_token": API.token! as AnyObject, "img": imageBase64String as AnyObject]) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                if res["status"].stringValue == "success" {
                    self.avatarImageView.image = chosenImage
                } else if res["status"].stringValue == "failure" {
                    let alertTitle = "Error"
                    let alertMessage = res["error_description"].stringValue
                    
                    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
