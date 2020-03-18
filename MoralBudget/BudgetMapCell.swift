//
//  BudgetMapCell.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 3/17/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import UIKit

class BudgetMapCell : UICollectionViewCell {
    
    @IBOutlet var percentageLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    public func setup(departmentInfo: DepartmentInfo, allocation: Double) {
        self.percentageLabel.text = "\(Int(allocation * 100.0))%"
        self.iconImageView.image = UIImage(named: departmentInfo.iconName)
        self.contentView.backgroundColor = departmentInfo.iconColor
    }
    
}
