//
//  Account.swift
//  Partime
//
//  Created by ShinCurry on 15/12/18.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import Foundation

enum Gender : String {
    case Male, Female
//    func rawValue() -> String {
//        switch self {
//        case .Male:
//            return NSLocalizedString("male", comment: "")
//        case .Female:
//            return NSLocalizedString("female", comment: "")
//        }
//    }
}

class Account: NSObject {
    var username : String?;
    //var password : String;
    var gender : Gender?;
    var about : String?;
    
    

    static func verify(username username : String, password : String) -> Bool {
        // TODO
        return false;
    }
}
