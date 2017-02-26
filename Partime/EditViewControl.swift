//
//  EditViewControl.swift
//  Partime
//
//  Created by ShinCurry on 16/2/27.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import Foundation

enum SelectionStatus {
    case selectSelf
    case selectOther
    case selectNone
}

/**
 *  Table View Edit View Cell
 *  isShow Data Struct
 */
struct EditViewControl {
    // (是否可以展开编辑 Cell, 是否隐藏)
    fileprivate let defaultHiddenStatus = [[(true, false), (false, true)], [(true, false), (false, true), (true, false), (false, true), (true, false), (false, true), (true, false), (false, true)], [(false, false), (false, false)]]
    
    var currentHiddenStatus: [[(Bool, Bool)]]
    init() {
        currentHiddenStatus = defaultHiddenStatus
    }
    
    mutating func selectionAt(_ indexPath: IndexPath) -> SelectionStatus {
        guard currentHiddenStatus[indexPath.section][indexPath.row].0 else {
            return .selectNone
        }
        
        guard currentHiddenStatus[indexPath.section][indexPath.row+1].1 else {
            currentHiddenStatus[indexPath.section][indexPath.row+1].1 = true
            return .selectSelf
        }
        
        currentHiddenStatus = defaultHiddenStatus
        currentHiddenStatus[indexPath.section][indexPath.row+1].1 = false
        return .selectOther
        
    }
}
