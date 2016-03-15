//
//  DropdownViewProtocol.swift
//  Partime
//
//  Created by ShinCurry on 16/3/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

//MARK: - DropdownView Delegate
@objc protocol DropdownViewDelegate {
    /**
     get the super view of the dropdown view.
     when the dropdown view expand table view, the super view will darken.
     
     - returns: super view of the dropdown view.
     */
    optional func superView() -> UIView
    
    /**
     set custom view for header in section
     
     - parameter dropdownView: The dropdown-view object asking for the title.
     - parameter section:      An index number identifying a section in dropdownView.
     
     - returns: custom view
     */
    optional func dropdownView(dropdownView: DropdownView, viewForHeaderInSection section: Int) -> UIView?
}

//MARK: - DropdownView DataSource
@objc protocol DropdownViewDataSource {
    /**
     Asks the data source to return the number of sections in the dropdown view.
     The number of sections in dropdownView. The default value is 3.
     
     - parameter dropdownView: The dropdown-view object asking for the title.
     
     - returns: number of sections
     */
    
    func numberOfSectionsInDropdownView(dropdownView: DropdownView) -> Int
    
    /**
     Tells the data source to return the number of rows in a given section of a dropdown view.
     
     - parameter dropdownView: The dropdown-view object asking for the title.
     - parameter section:      An index number identifying a section in dropdownView.
     
     - returns: The number of rows in section.
     */
    func dropdownView(dropdownView: DropdownView, numberOfRowsInSection section: Int) -> Int
    
    /**
     set header title of section
     
     - parameter dropdownView: The dropdown-view object asking for the title.
     - parameter section:      An index number identifying a section in dropdownView.
     
     - returns: title of section
     */
    func dropdownView(dropdownView: DropdownView,  titleForHeaderInSection section: Int) -> String
    
    /**
     Set row title of section
     
     - parameter dropdownView: The dropdown-view object asking for the title.
     - parameter indexPath:    current indexPath
     
     - returns: title of row
     */
    func dropdownView(dropdownView: DropdownView,  titleForRowAtIndexPath indexPath: NSIndexPath) -> String
}