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

    static var currentCity: JSON?
    
    static var allPlaces: JSON = {
        let jsonPath = NSBundle.mainBundle().pathForResource("address", ofType: "json")
        let jsonString = try! String(contentsOfFile: jsonPath!)
        
        let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        return JSON(data: dataFromString)
    }()
    
    

    
    static var hotCities = ["重庆市", "北京市", "上海市", "四川省"]

    
    lazy var manager = CLLocationManager()
}

extension Location: CLLocationManagerDelegate {
    func startLocation() {
        print("start")
        
        
        
    }
}
