//
//  AllJobsViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/3/12.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import YXMenuView

class AllJobsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewStyle()
        menuView.delegate = self
        menuView.dataSource = self
    }
    
    
    @IBOutlet weak var menuView: YXMenuView!
    
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
        menuView.tintColor = Theme.mainColor
    }
}


extension AllJobsViewController: YXMenuViewDelegate, YXMenuViewDataSource {
    func numberOfSectionsInYXMenuView(menuView: YXMenuView) -> Int {
        return titleForSections.count
    }
    func menuView(menuView: YXMenuView, numberOfRowsInSection section: Int) -> Int {
        return titleForRows[section].count
    }
    func menuView(menuView: YXMenuView, titleForHeaderInSection section: Int) -> String {
        return titleForSections[section]
    }
    func menuView(menuView: YXMenuView, titleForRowAtIndexPath indexPath: NSIndexPath) -> String {
        return titleForRows[indexPath.section][indexPath.row]
    }
}