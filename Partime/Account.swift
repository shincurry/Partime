//
//  Account.swift
//  Partime
//
//  Created by ShinCurry on 15/12/18.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import Foundation


enum Gender : String {
    case Male = "男"
    case Female = "女"
    
}

class Account {
    var username : String?;
    //var password : String;
    var gender : Gender?;
    var about : String?;
    
    

    static func verify(username username : String, password : String) -> Bool {
        // TODO
        return false;
    }
}
