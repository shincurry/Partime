//
//  Location.swift
//  Partime
//
//  Created by ShinCurry on 16/2/16.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class Location: NSObject {
    static var location: [String] = { _ in
        if let dataPath = NSBundle.mainBundle().pathForResource("address", ofType: "plist") {
            if let locationDictionary = NSDictionary(contentsOfFile: dataPath) {
                if let locationArray = locationDictionary["address"] as! [AnyObject]? {
                    return locationArray.map({ local in
                        let local = local as! NSDictionary
                        return local["name"] as! String
                    })
                }
            }
        }
        return []
    }()
}
