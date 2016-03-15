//
//  Theme.swift
//  Partime
//
//  Created by ShinCurry on 16/2/27.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class Theme {
//    static let mainColor = UIColor(red: 147/255.0, green: 44/255.0, blue: 48/255.0, alpha: 1)
    static let mainColor = UIColor(hue: 27 / 360.0, saturation: 0.76, brightness: 0.94, alpha: 1.00)
    static let mainTranslucentColor = UIColor(hue: 28 / 360.0, saturation: 0.73, brightness: 0.89, alpha: 1.00)
    static let backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1.00)
    static let headerLeftColor = Theme.mainColor.translucent()
    static let headerBackgroundColor = UIColor(hue: 23 / 360.0, saturation: 0, brightness: 0.98, alpha: 1.00)
    
    static let separatorColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.9, alpha: 1.00)
}

extension UIColor {
    func translucent() -> UIColor {
        return self.colorWithAlphaComponent(0.7)
    }
}