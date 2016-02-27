//
//  Job.swift
//  Partime
//
//  Created by ShinCurry on 16/2/27.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import Foundation

class Job: NSObject {
    init(named title: String, on time: NSDate) {
        self.title = title
        self.time = time
    }
    
    var title: String
    var salary: String?
    var location: String?
    var time: NSDate
    var rate: Int?
    var jobContent: String?
    var company: Company?
    var tel: String?
}
