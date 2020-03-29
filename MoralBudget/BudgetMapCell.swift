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
    @IBOutlet var coinStackView: CoinStackView!
    
    public func setup(departmentInfo: DepartmentInfo, allocation: Double, offset: Double) {
        self.coinStackView.setup(numCoins: Int(allocation * 50.0))
        self.percentageLabel.text = "\(Int((allocation + offset) * 100.0))%"
        self.iconImageView.image = UIImage(named: departmentInfo.iconName)
        self.contentView.backgroundColor = departmentInfo.iconColor
        
        if offset > 0.0 {
            self.percentageLabel.textColor = .green
        } else if offset < 0.0 {
            self.percentageLabel.textColor = .red
        } else {
            self.percentageLabel.textColor = .black
        }
    }
    
}
