//
//  ProfileTableViewController.swift
//  
//
//  Created by ShinCurry on 16/1/17.
//
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialViewStyle()
        // Do any additional setup after loading the view.
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
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var walletCellImage: UIImageView!
    @IBOutlet weak var jobCellImage: UIImageView!
    @IBOutlet weak var favoriteCellImage: UIImageView!
    @IBOutlet weak var settingCellImage: UIImageView!
    
    
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
    
    
    
    

}

// MARK: - Navigation
extension ProfileTableViewController {
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch identifier {
        case "ShowLoginSegue":
            return !NSUserDefaults.standardUserDefaults().boolForKey("isLogin")
        default:
            return true
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

}