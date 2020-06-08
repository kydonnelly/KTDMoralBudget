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
    let category: BudgetCategory
    let caption: String
    let details: String
    let allocation: Double
}

extension DepartmentInfo {
    
    var name: String {
        return String(describing: self.category)
    }
    
    var iconName: String {
        return self.category.iconName
    }
    
    var iconColor: UIColor {
        return UIColor(hexValue: self.category.iconColorHex, alpha: 1)
    }
    
}
