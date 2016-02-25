//
//  SearchViewController.swift
//  Partime
//
//  Created by ShinCurry on 15/12/29.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSearchController()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var searchSuperView: UIView!
    var searchResultController: SearchResultViewController!
    var searchController: UISearchController!

    @IBOutlet weak var searchTableView: UITableView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
    private func initialSearchController() {
        searchResultController = SearchResultViewController(tableView: searchTableView)
        searchController = UISearchController(searchResultsController: searchResultController)
//        searchController.searchResultsUpdater = self
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.searchBar.sizeToFit()
        self.definesPresentationContext = true
        searchTableView.tableHeaderView = searchController.searchBar
        
    }
    
//    func didPresentSearchController(searchController: UISearchController) {
//        print("didPresentSearchController")
//    }
//    func willDismissSearchController(searchController: UISearchController) {
//        print("willDismissSearchController")
//    }
}

//extension SearchViewController: UISearchResultsUpdating {
//    
//}

// 热门搜索
// 历史搜索
// 分类筛选 x

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("hotSearch", comment: "")
        case 1:
            return NSLocalizedString("historySearch", comment: "")
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 10
        default:
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell")!
        switch indexPath.section {
        case 0:
            cell.textLabel!.text = "hot \(indexPath.row)"
            cell.imageView!.image = UIImage(named: "Fire")
        case 1:
            cell.imageView!.image = UIImage(named: "Time")
            cell.textLabel!.text = "history \(indexPath.row)"
        default:
            break
        }
        cell.imageView!.tintColor = UIColor.lightGrayColor()
        
        return cell
    }
}