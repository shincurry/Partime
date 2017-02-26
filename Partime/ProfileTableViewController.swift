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
//        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(updateProfile))
//        header?.lastUpdatedTimeLabel.isHidden = true
//        header?.stateLabel.isHidden = true
//        tableView.mj_header = header
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        clearsSelectionOnViewWillAppear NOT WORK on device
        if let selection = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selection, animated: true)
        }
        
        let flag = (API.token != nil) ? true : false
        jobButtons.forEach() { buttton in
            buttton.isEnabled = flag
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let api = API.shared
    let alert = YXAlert()
    let defaults = UserDefaults(suiteName: "ProfileDefaults")!
    
    @IBOutlet var jobButtons: [UIButton]!
    
    @IBOutlet weak var personalVerification: UIButton!
    @IBOutlet weak var enterpriseVerification: UIButton!
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var walletCellImage: UIImageView!
    @IBOutlet weak var jobCellImage: UIImageView!
    @IBOutlet weak var favoriteCellImage: UIImageView!
    @IBOutlet weak var settingCellImage: UIImageView!
    
    @IBOutlet weak var profileIdLabel: UILabel!
    @IBOutlet weak var profileStatusLabel: UILabel!
    
    fileprivate func initialViewStyle() {
        if let navigator = navigationController {
            navigator.navigationBar.barTintColor = Theme.mainColor
        }
        
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.shadowColor = UIColor.black.cgColor
        profileImage.layer.shadowOpacity = 0.8
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor(red: 0.800, green: 0.800, blue: 0.800, alpha: 1.00).cgColor
        
        tableView.backgroundColor = Theme.backgroundColor
        
        
//        walletCellImage.tintColor = UIColor(red: 0.961, green: 0.486, blue: 0.000, alpha: 1.00)
//        favoriteCellImage.tintColor = UIColor(red: 0.945, green: 0.769, blue: 0.059, alpha: 1.00)
//        jobCellImage.tintColor = UIColor(red: 0.031, green: 0.376, blue: 0.659, alpha: 1.00)
//        settingCellImage.tintColor = UIColor(red: 0.278, green: 0.278, blue: 0.278, alpha: 1.00)
    }
    
    
    
    @IBAction func logout(_ sender: UIButton) {
        let keychain = Keychain(service: "com.windisco.Partime")
        keychain["accessToken"] = nil
        API.token = nil
        alert.showNotificationAlert("成功", message: "成功退出登录", sender: self, completion: nil)
        updateLoginStatus()
        let flag = (API.token != nil) ? true : false
        jobButtons.forEach() { buttton in
            buttton.isEnabled = flag
        }
    }

    
    func updateLoginStatus() {
        if let _ = API.token {
            personalVerification.isHidden = defaults.bool(forKey: "ProfileIsPersonalVerified")
            enterpriseVerification.isHidden = defaults.bool(forKey: "ProfileIsEnterpriseVerified")
            
            profileIdLabel.text = defaults.object(forKey: "ProfileRealname") as? String
            
            profileStatusLabel.text = "已登录"
            
            if let uri = defaults.object(forKey: "ProfileAvatar") as? String {
                profileImage.sd_setImage(with: api.getImageUrl(uri), placeholderImage: UIImage(named: "DefaultProfile"))
            }
            
        } else {
            profileIdLabel.text = "用户名"
            profileStatusLabel.text = "你还未登录"
            personalVerification.isHidden = true
            enterpriseVerification.isHidden = true
            profileImage.image = UIImage(named: "DefaultProfile")
            
            
        }
        tableView.reloadData()
    }
    func updateProfile() {
        guard let _ = API.token else {
//            tableView.mj_header.endRefreshing()
            return
        }
        api.getProfile(["access_token": API.token! as AnyObject]) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                let data = res["result"]
                let defaults = UserDefaults(suiteName: "ProfileDefaults")!
                defaults.set(data["realname"].stringValue, forKey: "ProfileRealname")
                defaults.set(data["gender"].stringValue, forKey: "ProfileGender")
                defaults.set(data["birthday"].stringValue, forKey: "ProfileBirthday")
                
                defaults.set(data["districtid"].stringValue, forKey: "ProfileDistrictID")
                defaults.set(data["cityid"].stringValue, forKey: "ProfileCityID")
                defaults.set(data["provinceid"].stringValue, forKey: "ProfileProvinceID")
                defaults.set(data["city"].stringValue + " " + data["district"].stringValue, forKey: "ProfileLocationName")
                
                
                if let qq = data["qq"].string {
                    defaults.set(qq, forKey: "ProfileQQ")
                } else {
                    defaults.set("", forKey: "ProfileQQ")
                }
                if let email = data["email"].string {
                    defaults.set(email, forKey: "ProfileEmail")
                } else {
                    defaults.set("", forKey: "ProfileEmail")
                }
                
                
                if let stature = data["height"].int {
                    defaults.set(stature, forKey: "ProfileStature")
                } else {
                    defaults.set(0, forKey: "ProfileStature")
                }
                if let school = data["school"].string {
                    defaults.set(school, forKey: "ProfileSchool")
                } else {
                    defaults.set("", forKey: "ProfileSchool")
                }
                if let major = data["major"].string {
                    defaults.set(major, forKey: "ProfileMajor")
                } else {
                    defaults.set("", forKey: "ProfileMajor")
                }
                if let enrollYear = data["enrolyear"].string {
                    defaults.set(enrollYear, forKey: "ProfileEnrollYear")
                } else {
                    defaults.set("", forKey: "ProfileEnrollYear")
                }
                if let intro = data["introduction"].string {
                    defaults.set(intro, forKey: "ProfileIntroduction")
                } else {
                    defaults.set("", forKey: "ProfileIntroduction")
                }
                if let exp = data["workexperience"].string {
                    defaults.set(exp, forKey: "ProfileWorkExperience")
                } else {
                    defaults.set("", forKey: "ProfileWorkExperience")
                }
                if let avatar = data["protrait"].string {
                    defaults.set(avatar, forKey: "ProfileAvatar")
                } else {
                    defaults.set("", forKey: "ProfileAvatar")
                }
                if let cert = data["personcerticification"].int {
                    let bool = cert == 29 ? false : true
                    defaults.set(bool, forKey: "ProfileIsPersonalVerified")
                }
                if let cert = data["enterprisecertification"].int {
                    let bool = cert == 29 ? false : true
                    defaults.set(bool, forKey: "ProfileIsEnterpriseVerified")
                }
                
                defaults.synchronize()
                self.updateLoginStatus()
                
            case .failure(let error):
                print(error)
            }
//            self.tableView.mj_header.endRefreshing()
        }

    }

    
    @IBAction func unwindRegisterToProfileTableViewController(_ sender: UIStoryboardSegue) {
        
    }
}

// MARK: - Profile Table View Delegate
extension ProfileTableViewController {
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Theme.backgroundColor
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.imageView?.tintColor = UIColor.lightGray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            if let _ = API.token {
                performSegue(withIdentifier: "ShowProfileDetailSegue", sender: self)
            } else {
                performSegue(withIdentifier: "ShowLoginSegue", sender: self)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 0 {
            guard let _ = API.token else {
                return 0
            }
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

}

extension ProfileTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowEmployeeRequestJobSegue":
                let controller = segue.destination as! MyJobsTableViewController
                controller.type = (.employee, .request)

            case "ShowEmployeeHireJobSegue":
                let controller = segue.destination as! MyJobsTableViewController
                controller.type = (.employee, .hire)
            case "ShowEmployeeWorkingJobSegue":
                let controller = segue.destination as! MyJobsTableViewController
                controller.type = (.employee, .working)
            case "ShowEmployeeDoneJobSegue":
                let controller = segue.destination as! MyJobsTableViewController
                controller.type = (.employee, .done)
            case "ShowEmployerPublishJobSegue":
                let controller = segue.destination as! MyJobsTableViewController
                controller.type = (.employer, .request)
            case "ShowEmployerHireJobSegue":
                let controller = segue.destination as! MyJobsTableViewController
                controller.type = (.employer, .hire)
            case "ShowEmployerWorkingJobSegue":
                let controller = segue.destination as! MyJobsTableViewController
                controller.type = (.employer, .working)
            case "ShowEmployerDoneJobSegue":
                let controller = segue.destination as! MyJobsTableViewController
                controller.type = (.employer, .done)
            default:
                break
            }
        }
    }
}
