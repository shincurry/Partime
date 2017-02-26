//
//  SearchResultViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/2/25.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class SearchResultViewController: UITableViewController {
    
    convenience init(tableView: UITableView) {
        self.init()
        superTableView = tableView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var superTableView: UITableView!
    // MARK: - Table view data source
}


extension SearchResultViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = superTableView.dequeueReusableCell(withIdentifier: "searchCell")!
        cell.textLabel!.text = "result \(indexPath.row)"
        cell.tintColor = UIColor.lightGray
        return cell
    }
}
