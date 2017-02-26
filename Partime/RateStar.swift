//
//  RateStar.swift
//  Partime
//
//  Created by ShinCurry on 16/2/27.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import Foundation

enum RateStar: Int {
    case zero = 0, one, two, three, four, five
    
    init(score: Int) {
        self = RateStar(rawValue: score)!
    }
    
    func getStars() -> String {
        let value = self.rawValue
        var starString = ""
        for _ in 0..<value {
            starString += "★"
        }
        for _ in value..<5 {
            starString += "✩"
        }
        return starString
    }
}
