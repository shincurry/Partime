//
//  LocationViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/1/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        locationsTableView.delegate = self
        locationsTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var locationsTableView: UITableView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    let tempLocation = ["重庆", "成都", "上海", "北京", "南京", "香港", "澳门"]

}

// MARK: - Location TableView
extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("numberOfSectionsInTableView")
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 26
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationTableViewCell", forIndexPath: indexPath)
//        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "locationTableViewCell")
        print("ok")
        if let label = cell.textLabel {
            label.text = tempLocation[indexPath.row % 7]
        }
        return cell
    }
}