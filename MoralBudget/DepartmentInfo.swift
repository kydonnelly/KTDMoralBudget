//
//  DepartmentInfo.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 2/15/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import Foundation
import UIKit

struct DepartmentInfo {
    let name: String
    let caption: String
    let details: String
    let allocation: Double
    
    let iconName: String
    let hexColor: String
}

extension DepartmentInfo : Decodable { }

extension DepartmentInfo {
    
    var iconColor: UIColor {
        return UIColor(hexString: self.hexColor, alpha: 1)
    }
    
}
