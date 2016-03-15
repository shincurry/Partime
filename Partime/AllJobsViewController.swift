//
//  AllJobsViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/3/12.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class AllJobsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewStyle()
        dropdownView.delegate = self
        dropdownView.datasource = self
        
    }
    
    
    @IBOutlet weak var dropdownView: DropdownView!
    
    var titleForSections = ["区域", "时间", "类型"]
    var titleForRows = [
        ["重庆", "北京", "上海"],
        ["上午", "中午", "下午", "晚上"],
        ["派送", "调研", "家教", "导游", "打酱油"]]
}


extension AllJobsViewController {
    private func initialViewStyle() {
        automaticallyAdjustsScrollViewInsets = false
        if let navigator = navigationController {
            navigator.navigationBar.barTintColor = Theme.mainColor
        }
        dropdownView.tintColor = Theme.mainColor
    }
}


extension AllJobsViewController: DropdownViewDelegate, DropdownViewDataSource {
    func superView() -> UIView {
        return self.dropdownView
    }
    func numberOfSectionsInDropdownView(dropdownView: DropdownView) -> Int {
        return titleForSections.count
    }
    func dropdownView(dropdownView: DropdownView, numberOfRowsInSection section: Int) -> Int {
        return titleForRows[section].count
    }
    func dropdownView(dropdownView: DropdownView, titleForHeaderInSection section: Int) -> String {
        return titleForSections[section]
    }
    func dropdownView(dropdownView: DropdownView, titleForRowAtIndexPath indexPath: NSIndexPath) -> String {
        return titleForRows[indexPath.section][indexPath.row]
    }
}