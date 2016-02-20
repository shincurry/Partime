//
//  LocationViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/1/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionIndexColor = UIColor.grayColor()
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
                    destination.location = Location.allCities[index.section-2].1[index.row]
                }
                case "unwindHotCitiesToHomeViewController":
                let destination = segue.destinationViewController as! HomeViewController
                destination.location = (sender?.currentTitle)!
            default:
                break
            }
        }
    }
}

// MARK: - Location TableView Delegate and DataSource
extension LocationTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Location.allCities.count + 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return Location.allCities[section-2].1.count
        }
    }
    
   override  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("currentLocation", comment: "")
        } else if section == 1 {
            return NSLocalizedString("hotLocation", comment: "")
        } else {
            return Location.allCities[section-2].0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationCurrentCityCell", forIndexPath: indexPath)
            cell.textLabel!.text = NSUserDefaults.standardUserDefaults().valueForKey("location") as? String
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationHotCitiesTableViewCell", forIndexPath: indexPath) as! LocationHotCitiesTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationAllCitiesCell", forIndexPath: indexPath)
            cell.textLabel!.text = Location.allCities[indexPath.section-2].1[indexPath.row]
            return cell
        }
    }


    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return CGFloat(66 * (Location.hotCities.count / 3))
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        /// ???? 不知道这里为什么要三个［也许是 index 0, 1, 2 ... 的关系］
        var indexTitle: [String] = ["", "", ""]
        indexTitle += Location.allCities.map({ (title, _ ) in
            if title.characters.count == 2 {
                return " " + title + "   "
            } else {
                return title
            }
        })
        return indexTitle
    }
}