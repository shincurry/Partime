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
        searchController = UISearchController(searchResultsController: UITableViewController())
//        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        searchTableView.tableHeaderView = searchController.searchBar
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        print("didPresentSearchController")
//        searchController.searchBar.becomeFirstResponder()
    }
    func willDismissSearchController(searchController: UISearchController) {
        print("willDismissSearchController")
    }
}

//extension SearchViewController: UISearchResultsUpdating {
//    
//}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("filterTableCell")!
        return cell
    }
}