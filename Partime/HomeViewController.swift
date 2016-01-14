//
//  HomeViewController.swift
//  Partime
//
//  Created by ShinCurry on 15/12/29.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        if let tab = tabBarController {
            tab.tabBar.tintColor = UIColor.whiteColor()
        }
//        if let navigator = navigationController {
//            let color = UIColor(colorLiteralRed: 0.478, green: 0.145, blue: 0.145, alpha: 1.00)
////            navigator.navigationBar.tintColor = color
//            navigator.navigationBar.barTintColor = color
////            navigator.navigationBar.backgroundColor = UIColor(colorLiteralRed: 0.937, green: 0.824, blue: 0.537, alpha: 1.00)
//
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var jobsTableView: UITableView!
    @IBAction func showMoreButton(sender: UIButton) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("JobTableViewCell", forIndexPath: indexPath) as! JobsTableViewCell
        cell.initialization(index: indexPath.row, title: "Disco cashier", salary: "100 / day", time: "7:00 - 17:00", workplace: "CQ")
        return cell
    }
    
    
}