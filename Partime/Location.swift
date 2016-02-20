//
//  Location.swift
//  Partime
//
//  Created by ShinCurry on 16/2/16.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import CoreLocation

class Location: NSObject {

    static var allCities: [(String, [String])] = {
        var data = [(String, [String])]()
        if let dataPath = NSBundle.mainBundle().pathForResource("address", ofType: "plist") {
            if let locationDictionary = NSArray(contentsOfFile: dataPath) as? [NSDictionary] {
                for local in locationDictionary {
                    let province = local["state"] as! String
                    let cities = (local["cities"] as! [NSDictionary]).map({ city in
                        return city["city"] as! String
                    })
                    data.append((province, cities))
                }
            }
        }
        return data
    }()
    
    static var hotCities = ["重庆", "北京", "上海", "深圳", "香港", "广州", "北京", "上海", "深圳", "香港", "广州"]
    
    lazy var manager = CLLocationManager()
}

extension Location: CLLocationManagerDelegate {
    func startLocation() {
        print("start")
    }
}
