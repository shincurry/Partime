//
//  Location.swift
//  Partime
//
//  Created by ShinCurry on 16/2/16.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class Location: NSObject {
    static var data: [AnyObject] = { _ in
        if let dataPath = NSBundle.mainBundle().pathForResource("address", ofType: "plist") {
            if let locationDictionary = NSDictionary(contentsOfFile: dataPath) {
                if let locationArray = locationDictionary["address"] {
                    return locationArray as! [AnyObject]
                }
            }
        }
        return [""]
    }()
    
    static func getProvince() -> [String] {
        return data.map({ local in
            let local = local as! NSDictionary
                return local["name"] as! String
        })
    }
    static func getCitiesIn(provinceIndex index: Int) -> [String] {
        let sub = data[index]["sub"] as! [AnyObject]
        return sub.map({ city in
            return city["name"] as! String
        })
    }
}
