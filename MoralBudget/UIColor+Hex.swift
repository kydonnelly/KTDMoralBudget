//
//  UIColor+Hex.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 3/3/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init(hexValue: UInt, alpha: CGFloat) {
        self.init(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hexValue & 0xFF00) >> 8) / 255.0,
                  blue: CGFloat(hexValue & 0xFF) / 255.0,
                  alpha: alpha)
    }
    
    public convenience init(hexString: String, alpha: CGFloat) {
        var hexValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&hexValue)
        
        self.init(hexValue: UInt(hexValue), alpha: alpha)
    }
    
}
