//
//  LocationViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/1/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import SwiftyJSON

class LocationTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionIndexColor = UIColor.grayColor()
        tableView.sectionIndexBackgroundColor = UIColor(white: 1, alpha: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "unwindAllCitiesToHomeViewController":
                let destination = segue.destinationViewController as! HomeViewController
                if let index = tableView.indexPathForSelectedRow {
                    destination.location = Location.allPlaces.array![index.section-2]["sub"].array![index.row]["value"]["name"].stringValue
//                    Location.currentCity = Location.allPlaces.array![index.section-2]["sub"].array![index.row]["value"]
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setInteger(index.section-2, forKey: "CurrentProvincePath")
                    defaults.setInteger(index.row, forKey: "CurrentCityPath")
                    
                }
                case "unwindHotCitiesToHomeViewController":
                let destination = segue.destinationViewController as! HomeViewController
                destination.location = (sender?.currentTitle)!
                // !!!
//                Location.currentCity = Location.allProvinces[sender!.tag]
            default:
                break
            }
        }
    }
}

// MARK: - Location TableView Delegate and DataSource
extension LocationTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2 + Location.allPlaces.array!.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return Location.allPlaces.array![section-2]["sub"].array!.count
        }
    }
    
    override  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "当前位置"
        case 1:
            return "热门位置"
        default:
            return Location.allPlaces.array![section-2]["value"]["name"].stringValue
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationCurrentCityCell", forIndexPath: indexPath)
            cell.textLabel!.text = NSUserDefaults.standardUserDefaults().valueForKey("location") as? String
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationHotCitiesTableViewCell", forIndexPath: indexPath) as! LocationHotCitiesTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationAllCitiesCell", forIndexPath: indexPath)
            cell.textLabel!.text = Location.allPlaces.array![indexPath.section-2]["sub"].array![indexPath.row]["value"]["name"].stringValue
            return cell
        }
    }


    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 0 // 暂时屏蔽
            
            
            // 需要改进？
//            var count = Location.hotProvinces.count / 3
//            if Location.hotProvinces.count % 3 != 0 {
//                count += 1
//            }   
            let count = 2
            return CGFloat(66 * count)
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
}