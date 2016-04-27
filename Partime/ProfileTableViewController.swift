//
//  ProfileTableViewController.swift
//  
//
//  Created by ShinCurry on 16/1/17.
//
//

import UIKit
import KeychainAccess
import SDWebImage
import MJRefresh
import SwiftyJSON

class ProfileTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewStyle()
        // Do any additional setup after loading the view.
        updateLoginStatus()
//        tableView.mj_header = MJRefreshHeader(refreshingTarget: self, refreshingAction: #selector(updateProfile))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        clearsSelectionOnViewWillAppear NOT WORK on device
        if let selection = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selection, animated: true)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let api = API.shared
    let alert = YXAlert()
    let defaults = NSUserDefaults(suiteName: "ProfileDefaults")!
    
    @IBOutlet weak var personalVerification: UIButton!
    @IBOutlet weak var enterpriseVerification: UIButton!
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var walletCellImage: UIImageView!
    @IBOutlet weak var jobCellImage: UIImageView!
    @IBOutlet weak var favoriteCellImage: UIImageView!
    @IBOutlet weak var settingCellImage: UIImageView!
    
    @IBOutlet weak var profileIdLabel: UILabel!
    @IBOutlet weak var profileStatusLabel: UILabel!
    
    
    
    private func initialViewStyle() {
        if let navigator = navigationController {
            navigator.navigationBar.barTintColor = Theme.mainColor
        }
        
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.shadowColor = UIColor.blackColor().CGColor
        profileImage.layer.shadowOpacity = 0.8
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor(red: 0.800, green: 0.800, blue: 0.800, alpha: 1.00).CGColor
        
        tableView.backgroundColor = Theme.backgroundColor
        
        
//        walletCellImage.tintColor = UIColor(red: 0.961, green: 0.486, blue: 0.000, alpha: 1.00)
//        favoriteCellImage.tintColor = UIColor(red: 0.945, green: 0.769, blue: 0.059, alpha: 1.00)
//        jobCellImage.tintColor = UIColor(red: 0.031, green: 0.376, blue: 0.659, alpha: 1.00)
//        settingCellImage.tintColor = UIColor(red: 0.278, green: 0.278, blue: 0.278, alpha: 1.00)
    }
    
    
    
    @IBAction func logout(sender: UIButton) {
        let keychain = Keychain(service: "com.windisco.Partime")
        keychain["accessToken"] = nil
        API.token = nil
        alert.showNotificationAlert("成功", message: "成功退出登录", sender: self, completion: nil)
//        for key in defaults.dictionaryRepresentation().keys {
//            defaults.removeObjectForKey(key)
//        }
//        defaults.synchronize()
        
        updateLoginStatus()
    }

    
    func updateLoginStatus(refresh refresh: Bool = false) {
        if let _ = API.token {
            personalVerification.hidden = false
            enterpriseVerification.hidden = false
            
            profileIdLabel.text = defaults.objectForKey("ProfileRealname") as? String
            
            profileStatusLabel.text = "已登录"
            
            if let uri = defaults.objectForKey("ProfileAvatar") as? String {
                print("image uri : \(uri)")
                if refresh {
                    profileImage.sd_setImageWithURL(api.getImageUrl(uri), placeholderImage: UIImage(named: "DefaultProfile"), options: .RefreshCached)
                } else {
                    profileImage.sd_setImageWithURL(api.getImageUrl(uri), placeholderImage: UIImage(named: "DefaultProfile"))
                }
                
            }
            
        } else {
            profileIdLabel.text = "用户名"
            profileStatusLabel.text = "你还未登录"
            personalVerification.hidden = true
            enterpriseVerification.hidden = true
            profileImage.image = UIImage(named: "DefaultProfile")
            
            
        }
        tableView.reloadData()
    }
    func updateProfile() {
        api.getProfile(["access_token": API.token!]) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                let data = res["result"]
                let defaults = NSUserDefaults.standardUserDefaults()
                print("realname: \(data["realname"].stringValue)")
                defaults.setObject(data["realname"].stringValue, forKey: "ProfileRealname")
                defaults.setObject(data["gender"].stringValue, forKey: "ProfileGender")
                defaults.setObject(data["birthday"].stringValue, forKey: "ProfileBirthday")
                defaults.setObject(data["cityid"].stringValue, forKey: "ProfileCityID")
                
                if let qq = data["qq"].string {
                    defaults.setObject(qq, forKey: "ProfileQQ")
                }
                if let email = data["email"].string {
                    defaults.setObject(email, forKey: "ProfileEmail")
                }
                
                
                if let stature = data["height"].string {
                    if let value = Int(stature) {
                        defaults.setInteger(value, forKey: "ProfileStature")
                    }
                }
                if let school = data["school"].string {
                    defaults.setObject(school, forKey: "ProfileSchool")
                }
                if let major = data["major"].string {
                    defaults.setObject(major, forKey: "ProfileMajor")
                }
                if let enrollYear = data["enrolyear"].string {
                    defaults.setObject(enrollYear, forKey: "ProfileEnrollYear")
                }
                if let intro = data["introduction"].string {
                    defaults.setObject(intro, forKey: "ProfileIntroduction")
                }
                if let exp = data["workexperience"].string {
                    defaults.setObject(exp, forKey: "ProfileWorkExperience")
                }
                print(data["protrait"].stringValue)
                if let avatar = data["protrait"].string {
                    defaults.setObject(avatar, forKey: "ProfileAvatar")
                }
                print("ok")
                defaults.synchronize()
                self.updateLoginStatus()
            case .Failure(let error):
                print(error)
            }
            
            
            
        }
    }

}

// MARK: - Profile Table View Delegate
extension ProfileTableViewController {
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Theme.backgroundColor
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.imageView?.tintColor = UIColor.lightGrayColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            if let _ = API.token {
                performSegueWithIdentifier("ShowProfileDetailSegue", sender: self)
            } else {
                performSegueWithIdentifier("ShowLoginSegue", sender: self)
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 0 {
            guard let _ = API.token else {
                return 0
            }
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }

}