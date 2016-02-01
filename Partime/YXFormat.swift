//
//  InputVerify.swift
//  Partime
//
//  Created by ShinCurry on 16/1/27.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import Foundation

enum FormatType {
    case PhoneNumber
    case Email
    case ID
    case Password
    case None
}

struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern,
            options: .CaseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matchesInString(input,
            options: [],
            range: NSMakeRange(0, input.characters.count)) {
                return matches.count > 0
        } else {
            return false
        }
    }
}

infix operator =~ {
    associativity none
    precedence 130
}

func =~ (lhs: String, rhs: String) -> Bool {
    return MyRegex(rhs).match(lhs)
}

class YXFormat {
    func verifyByAccount(text: String) -> (Bool, FormatType) {
        if verifyByPhoneNumber(text) {
            return (true, .PhoneNumber)
        }
        if verifyByEmail(text) {
            return (true, .Email)
        }
        if verifyByID(text) {
            return (true, .ID)
        }
        
        
        return (false, .None)
    }
    
    
    func verifyByEmail(text: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        if text =~ emailPattern {
            return true
        } else {
            return false
        }
    }
    
    func verifyByPhoneNumber(text: String) -> Bool {
        let phonePattern = "^1[0-9]{10}$"
        if text =~ phonePattern {
            return true
        } else {
            return false
        }
    }
    
    func verifyByID(text: String) -> Bool {
        let idPattern = "\\D[a-zA-Z0-9_]{5,15}$"
        if text =~ idPattern {
            return true
        } else {
            return false
        }
    }
    
    func verifyByPassword(text: String) -> Bool {
        if text.characters.count >= 6 {
            return true
        } else {
            return false
        }
    }
}
