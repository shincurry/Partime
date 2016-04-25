//
//  ProfileTableViewController.swift
//  
//
//  Created by ShinCurry on 16/1/17.
//
//

import UIKit
import KeychainAccess

class ProfileTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewStyle()
        // Do any additional setup after loading the view.
        updateLoginStatus()
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
    
    let alert = YXAlert()
    
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
        alert.showNotificationAlert("Success", message: "Logout successfully", sender: self, completion: nil)
        updateLoginStatus()
    }

    
    func updateLoginStatus() {
        if let _ = API.token {
            let defaults = NSUserDefaults.standardUserDefaults()
            print("ProfileRealname")
            print(defaults.objectForKey("ProfileRealname") as? String)
            profileIdLabel.text = defaults.objectForKey("ProfileRealname") as? String
            
            profileStatusLabel.text = "You have logged in."
        } else {
            profileIdLabel.text = "用户名"
            profileStatusLabel.text = "你还未登录"
        }
        tableView.reloadData()
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