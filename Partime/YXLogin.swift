//
//  LoginVerify.swift
//  Partime
//
//  Created by ShinCurry on 16/1/27.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import Foundation

class YXLogin: NSObject {
    let format = YXFormat()
    func verify(account account: String, password: String) -> (Bool, FormatType, Bool) {
        let (accountResult, type) = format.verifyByAccount(account)
        
        let passwordResult = format.verifyByPassword(password)
        
        return (accountResult, type, passwordResult)
        
//        return accountResult && passwordResult
    }
}