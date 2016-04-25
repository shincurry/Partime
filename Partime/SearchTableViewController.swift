//
//  SearchViewController.swift
//  Partime
//
//  Created by ShinCurry on 15/12/29.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit
import MJRefresh

class SearchTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSearchController()
        initialViewStyle()
        
    }
    
    func loadNewData() {
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        searchResultController.view.removeFromSuperview()
        searchController.view.removeFromSuperview()
    }
    
    var hotData = ["发传单", "收银员", "柜台", "家教", "做清洁"]
    var historyData = ["发传单", "传单", "麦当劳"]
    
    var searchResultController: SearchResultViewController!
    var searchController: UISearchController!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var clearHistoryButton: UIButton!

    @IBAction func clearHistory(sender: UIButton) {
        let alertTitle = NSLocalizedString("clearHistoryAlertTitle", comment: "")
        let alertMessage = NSLocalizedString("clearHistoryAlertMessage", comment: "")
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        alertController.view.tintColor = Theme.mainColor
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default) { (action) in
            self.historyData.removeAll()
            self.tableView.reloadData()
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

extension SearchTableViewController {
    private func initialViewStyle() {
        clearHistoryButton.setTitleColor(Theme.mainColor, forState: .Normal)
        clearHistoryButton.layer.borderWidth = 1
        clearHistoryButton.layer.borderColor = Theme.mainColor.CGColor
        clearHistoryButton.layer.cornerRadius = clearHistoryButton.frame.size.width / 14.0
        clearHistoryButton.clipsToBounds = true
    }
}


extension SearchTableViewController {
    // navigationBar 需要设置为 Translucent 才能正常隐藏 navigation
    private func initialSearchController() {
        searchResultController = SearchResultViewController(tableView: tableView)
        searchController = UISearchController(searchResultsController: searchResultController)
//        searchController.searchResultsUpdater = self
        
//        searchController.delegate = self
//        searchController.searchBar.delegate = self
        
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    
}

//extension SearchViewController: UISearchResultsUpdating {
//    
//}

// 热门搜索
// 历史搜索
// 分类筛选 x

// MARK: - Search Hot and history Table View DataSource and Delegate
extension SearchTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("hotSearch", comment: "")
        case 1:
            return NSLocalizedString("historySearch", comment: "")
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return hotData.count
        case 1:
            return historyData.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell")!
        switch indexPath.section {
        case 0:
            cell.textLabel!.text = hotData[indexPath.row]
            cell.imageView!.image = UIImage(named: "Fire")
        case 1:
            cell.textLabel!.text = historyData[indexPath.row]
            cell.imageView!.image = UIImage(named: "Time")
        default:
            break
        }
        cell.imageView!.tintColor = UIColor.lightGrayColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            historyData.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}