//
//  Location.swift
//  Partime
//
//  Created by ShinCurry on 16/2/16.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class Location: NSObject {
    
    static var allPlaces: JSON = {
        let jsonPath = Bundle.main.path(forResource: "address", ofType: "json")
        let jsonString = try! String(contentsOfFile: jsonPath!)
        
        let dataFromString = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        return JSON(data: dataFromString)
    }()
    
    static var hotCities = ["重庆市", "北京市", "上海市", "四川省"]

    
    lazy var manager = CLLocationManager()
    
    static func getCurrentCounties() -> [JSON] {
        let defaults = UserDefaults.standard
        let provincePath = defaults.integer(forKey: "CurrentProvincePath")
        let cityPath = defaults.integer(forKey: "CurrentCityPath")
        return allPlaces.array![provincePath]["sub"].array![cityPath]["sub"].array!
    }
    
    static func getCounty(byCode code: String) -> JSON? {
        print(code)
        let defaults = UserDefaults.standard
        let provincePath = defaults.integer(forKey: "CurrentProvincePath")
        let cityPath = defaults.integer(forKey: "CurrentCityPath")
        let result = allPlaces.array![provincePath]["sub"].array![cityPath]["sub"].array!.filter({ county in
            return (county["code"].stringValue == code)
        })

        if result.isEmpty {
            return nil
        } else {
            return result[0]
        }
    }
}

extension Location: CLLocationManagerDelegate {
    func startLocation() {
        print("start")
        
        let manager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }

        
    }
}
