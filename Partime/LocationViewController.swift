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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var locationsTableView: UITableView!

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "unwindToHomeViewController":
                let destination = segue.destinationViewController as! HomeViewController
                if let index = locationsTableView.indexPathForSelectedRow {
                    destination.location = Location.location[index.row]
                }
                print("ok")
            default:
                break
            }
        }
        
    }

}

// MARK: - Location TableView Delegate and DataSource
extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Location.location.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationTableViewCell", forIndexPath: indexPath)

        cell.textLabel!.text = Location.location[indexPath.row]

        return cell
    }
}