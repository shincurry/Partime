//
//  DropdownView.swift
//  Partime
//
//  Created by ShinCurry on 16/3/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class DropdownView: UIView {
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        initBaseView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBaseView()
    }
    
    var selections: DropdownViewSelection!
    let defaultTag = 3000
    
    var view: UIView!
    var shadowView: UIView!
    
    //MARK: - Default Properties
    
    var numberOfSections = 3
    var numberOfRowsInSection = [3, 3, 3]
    var titleForSections = ["Stark", "Sakura", "Hoppou"]
    var titleForRowsInSection = [
    ["Apple", "Banana", "Blueberry"],
    ["Cherry", "Grape", "Lemon"],
    ["Mango", "Peach", "Pear"]]
    
    
    override var tintColor: UIColor! {
        didSet {
            sectionViews.forEach() { sectionView in
                sectionView.tintColor = themeColor
            }
        }
    }
    
    var themeColor: UIColor! {
        didSet {
            sectionViews.forEach() { sectionView in
                sectionView.tintColor = themeColor
            }
        }
    }
    
    var delegate: DropdownViewDelegate? {
        didSet {
            setDelegate()
        }
    }
    var datasource: DropdownViewDataSource? {
        didSet {
            setDataSource()
            updateHeaderView()
        }
    }
    
    
    var dropDownSuperView: UIView!
    var sectionViews: [DropdownSectionView]!
    @IBOutlet weak var dropdownHeaderView: UIView!
    var expansionHeight: CGFloat!
    var collapseHeight: CGFloat!
    var maxTableViewHeight: CGFloat!
    @IBOutlet weak var dropdownTableView: UITableView!
    
    // load view from xib
    func loadViewFfromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func initBaseView() {
        sectionViews = [DropdownSectionView]()
        view = loadViewFfromNib()
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        view.frame = bounds
        
        initHeaderView(numberOfSections)
        
        maxTableViewHeight = 280
        collapseHeight = dropdownHeaderView.frame.size.height
        expansionHeight = collapseHeight + maxTableViewHeight
        self.view.frame.size.height = collapseHeight
        self.frame.size.height = collapseHeight
        addSubview(view)
    }
    
    func initHeaderView(sectionNumber: Int) {

        selections = DropdownViewSelection(numberOfSelection: sectionNumber)
        let fullWidth = view.frame.size.width - CGFloat(sectionNumber-1)
        let buttonWidth = fullWidth / CGFloat(sectionNumber)
        for index in 0..<sectionNumber {
            let sectionView = DropdownSectionView(frame: CGRectMake(CGFloat(index) * buttonWidth, 0, buttonWidth, 44.0))
            let button = sectionView.headerButton
            button.addTarget(self, action: "touch:", forControlEvents: .TouchUpInside)
            button.tag = defaultTag + index
            button.setTitle(titleForSections[index], forState: .Normal)
            sectionView.tintColor = tintColor
            dropdownHeaderView.addSubview(sectionView)
            sectionViews.append(sectionView)
        }
    }
    
    func updateHeaderView() {
        for view in sectionViews {
            view.removeFromSuperview()
        }
        sectionViews.removeAll()
        let numberOfSections = datasource!.numberOfSectionsInDropdownView(self)
        initHeaderView(numberOfSections)
    }
    
    func setDelegate() {
        dropDownSuperView = delegate!.superView!()
    }
    func setDataSource() {
//        titleForSections.removeAll()
//        titleForRowsInSection.removeAll()
//        numberOfRowInSection.removeAll()
        
//        numberOfSections = datasource!.numberOfSectionsInDropdownView(self)
//        
//        for section in 0..<numberOfSections {
//            titleForSections.append(datasource!.dropdownView(self, titleForHeaderInSection: section))
//            numberOfRowInSection.append(datasource!.dropdownView(self, numberOfRowsInSection: section))
//            titleForRowsInSection.append([String]())
//            for row in 0..<numberOfRowInSection[section] {
//                let indexPath = NSIndexPath(forRow: row, inSection: section)
//                titleForRowsInSection[section].append(datasource!.dropdownView(self, titleForRowAtIndexPath: indexPath))
//            }
//
//        }
        
//        print("numberOfSections \(numberOfSections)")
//        print("numberOfRowInSection \(numberOfRowInSection)")
//        print("titleForRowsInSection \(titleForRowsInSection)")
    }
}

extension DropdownView {
    func touch(sender: UIButton) {
        let sectionIndex = sender.tag - defaultTag
        let status = selections.selectionAt(sectionIndex)
 
        for index in 0..<selections.numberOfSelection {
            sectionViews[index].highlighted = selections.currentStatus[index]
        }
        
        switch status {
        case .SelectOne:
            self.expandTableView() {}
        case .SelectSelf:
            collapseTableView() {}
        case .SelectOther:
            collapseTableView() {
                self.dropdownTableView.reloadData()
                self.expandTableView() {}
            }
        default:
            break
        }
    }
    
    func collapseTableView(completion: () -> Void) {
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseInOut, animations: {
            self.dropdownTableView.alpha = 0.2
            self.view.frame.size.height = self.collapseHeight
            self.view.layoutIfNeeded()
            }, completion: { _ in
                self.frame.size.height = self.collapseHeight
                completion()
        })
    }
    func expandTableView(completion: () -> Void) {
        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: {
            self.dropdownTableView.alpha = 1
            self.view.frame.size.height = self.expansionHeight
            self.view.layoutIfNeeded()
            }, completion: { _ in
                self.frame.size.height = self.expansionHeight
                completion()
        })
    }
}

extension DropdownView {
    func reloadData() {
//        setDelegate()
//        setDataSource()
        dropdownTableView.reloadData()
    }
}


extension DropdownView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return datasource!.numberOfSectionsInDropdownView(self)
//        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("section \(section)")
        print(datasource!.dropdownView(self, numberOfRowsInSection: section))
        return datasource!.dropdownView(self, numberOfRowsInSection: section)

//        return numberOfRowInSection[0]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("section-\(indexPath.section) and row-\(indexPath.row)")
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "DropdownCell")
//        cell.textLabel!.text = titleForRowsInSection[indexPath.section][indexPath.row]
        
        cell.textLabel!.text = datasource!.dropdownView(self, titleForRowAtIndexPath: indexPath)
        
//        print(titleForRowsInSection[indexPath.section][indexPath.row])
        return cell
    }
}