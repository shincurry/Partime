//
//  Company.swift
//  Partime
//
//  Created by ShinCurry on 16/2/27.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class Company: NSObject {
    init(named name: String) {
        self.name = name
    }
    var name: String
    var link: String?
}
