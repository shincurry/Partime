//
//  DropdownView.swift
//  Partime
//
//  Created by ShinCurry on 16/3/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class DropdownView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initBaseView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBaseView()
    }
    
    var selections: DropdownViewSelection!
    let defaultTag = 3000
    
    var view: UIView!
    var shadowView: UIView!
    
    //MARK: - Default Data
    var titleForSections = ["Stark", "Sakura", "Hoppou"]
    var titleForRowsInSection = [
    ["Apple", "Banana", "Blueberry"],
    ["Cherry", "Grape", "Lemon"],
    ["Mango", "Peach", "Pear"]]
    
    
    //MARK: - Properties
    override var tintColor: UIColor! {
        didSet {
            sectionViews.forEach() { sectionView in
                sectionView.tintColor = tintColor
            }
        }
    }
    
    var delegate: DropdownViewDelegate? {
        didSet {
            
        }
    }
    var datasource: DropdownViewDataSource? {
        didSet {
            updateHeaderView()
        }
    }
    
    var dropDownSuperView: UIView!
    var sectionViews: [DropdownSectionView]!
    @IBOutlet weak var dropdownHeaderView: UIView!
    var expansionHeight: CGFloat!
    var collapseHeight: CGFloat!
    var maxTableViewHeight: CGFloat = 44 * 3
    @IBOutlet weak var dropdownTableView: UITableView!
    
}

// MARK: - View
extension DropdownView {
    func initBaseView() {
        sectionViews = [DropdownSectionView]()
        view = loadViewFfromNib()
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]        
        view.frame = bounds
        
        initHeaderView(titleForSections.count)
        
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
        let buttonHeight = dropdownHeaderView.frame.size.height
        for index in 0..<sectionNumber {
            let sectionView = DropdownSectionView(frame: CGRectMake(CGFloat(index) * buttonWidth, 0, buttonWidth, buttonHeight))
            let button = sectionView.headerButton
            button.addTarget(self, action: "selectSection:", forControlEvents: .TouchUpInside)
            button.tag = defaultTag + index
            button.setTitle(titleForSections[index], forState: .Normal)
            sectionView.tintColor = tintColor
            dropdownHeaderView.addSubview(sectionView)
            sectionViews.append(sectionView)
        }
    }
    
    func updateHeaderView() {
        sectionViews.forEach() { sectionView in
            sectionView.removeFromSuperview()
        }
        sectionViews.removeAll()
        
        let numberOfSections = datasource!.numberOfSectionsInDropdownView(self)
        initHeaderView(numberOfSections)
        
        reloadHeaderData()
    }
    
    // load view from xib
    func loadViewFfromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
}

// MARK: - View Reaction and Animation
extension DropdownView {
    func selectSection(sender: UIButton) {
        let sectionIndex = sender.tag - defaultTag
        let status = selections.selectionAt(sectionIndex)
        
        EnumerateSequence(sectionViews).forEach() { (index, sectionView) in
            sectionView.highlighted = selections.currentStatus[index]
        }
        
        switch status {
        case .SelectOne:
            self.expandTableView({})
        case .SelectSelf:
            collapseTableView({})
        case .SelectOther:
            collapseTableView() {
                self.dropdownTableView.reloadData()
                self.expandTableView({})
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
                self.layoutIfNeeded()
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
                self.layoutIfNeeded()
                completion()
        })
        
    }
}

// MARK: - Data
extension DropdownView {
    private func reloadHeaderData() {
        if let data = datasource {
            EnumerateSequence(sectionViews).forEach() { (index, sectionView) in
                sectionView.headerButton.setTitle(data.dropdownView(self, titleForHeaderInSection: index), forState: .Normal)
            }
        }
    }
    
    func reloadData() {
        reloadHeaderData()
        dropdownTableView.reloadData()
    }
}

// MARK: - TableView Delegate and DataSource
extension DropdownView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let data = datasource {
            return data.numberOfSectionsInDropdownView(self)
        } else {
            return titleForSections.count
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == selections.currentIndex else {
            return 0
        }
        
        if let data = datasource {
            return data.dropdownView(self, numberOfRowsInSection: selections.currentIndex)
        } else {
            return titleForRowsInSection[section].count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "DropdownCell")

        if let data = datasource {
            cell.textLabel!.text = data.dropdownView(self, titleForRowAtIndexPath: indexPath)
        } else {
            cell.textLabel!.text = titleForRowsInSection[indexPath.section][indexPath.row]
        }
        return cell
    }
}