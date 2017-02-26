//
//  InputVerify.swift
//  Partime
//
//  Created by ShinCurry on 16/1/27.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import Foundation

enum FormatType {
    case phoneNumber
    case email
    case id
    case password
    case none
}

struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern,
            options: .caseInsensitive)
    }
    
    func match(_ input: String) -> Bool {
        if let matches = regex?.matches(in: input,
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

class YXFormat: NSObject {
    func verifyByAccount(_ text: String) -> (Bool, FormatType) {
        if verifyByPhoneNumber(text) {
            return (true, .phoneNumber)
        }
        if verifyByEmail(text) {
            return (true, .email)
        }
        if verifyByID(text) {
            return (true, .id)
        }
        
        
        return (false, .none)
    }
    
    
    func verifyByEmail(_ text: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        if text =~ emailPattern {
            return true
        } else {
            return false
        }
    }
    
    func verifyByPhoneNumber(_ text: String) -> Bool {
        let phonePattern = "^1[0-9]{10}$"
        if text =~ phonePattern {
            return true
        } else {
            return false
        }
    }
    
    func verifyByID(_ text: String) -> Bool {
        let idPattern = "\\D[a-zA-Z0-9_]{5,15}$"
        if text =~ idPattern {
            return true
        } else {
            return false
        }
    }
    
    func verifyByPassword(_ text: String) -> Bool {
        if text.characters.count >= 6 {
            return true
        } else {
            return false
        }
    }
}
