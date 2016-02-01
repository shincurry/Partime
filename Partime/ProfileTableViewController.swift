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
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.shadowColor = UIColor.blackColor().CGColor
        profileImage.layer.shadowOpacity = 0.8
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor(red: 0.800, green: 0.800, blue: 0.800, alpha: 1.00).CGColor
        
        tableView.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1.00)
        
        walletCellImage.tintColor = UIColor(red: 0.961, green: 0.486, blue: 0.000, alpha: 1.00)
        //        walletCellImage.tintColor = UIColor(hue: 30.37 / 360.0, saturation: 0.71, brightness: 0.62, alpha: 1.00)
        favoriteCellImage.tintColor = UIColor(red: 0.945, green: 0.769, blue: 0.059, alpha: 1.00)
        jobCellImage.tintColor = UIColor(red: 0.031, green: 0.376, blue: 0.659, alpha: 1.00)
        settingCellImage.tintColor = UIColor(red: 0.278, green: 0.278, blue: 0.278, alpha: 1.00)
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let identifier = segue.identifier {
//        }
//    }
}

extension ProfileTableViewController {
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1.00)
    }

}