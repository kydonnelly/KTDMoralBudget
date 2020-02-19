//
//  DepartmentAllocationCell.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 2/17/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import UIKit

public class DepartmentAllocationCell : UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    @IBOutlet var myPercentageLabel: UILabel!
    @IBOutlet var cityPercentageLabel: UILabel!
    @IBOutlet var differenceLabel: UILabel!
    
    func setup(departmentInfo: DepartmentInfo, myAllocation: Double, cityAllocation: Double) {
        self.titleLabel.text = departmentInfo.name
        self.subtitleLabel.text = departmentInfo.caption
        
        self.myPercentageLabel.text = "You gave: \(round(myAllocation * 1000.0) / 10.0)%"
        self.cityPercentageLabel.text = "City gave: \(round(cityAllocation * 1000.0) / 10.0)%"
        self.differenceLabel.text = "Difference: \(round((myAllocation - cityAllocation) * 1000.0) / 10.0)%"
        
        // scale from green at 50% to red at -50%
        self.differenceLabel.textColor = UIColor(red: max(0.2, CGFloat(cityAllocation - myAllocation) * 4),
                                                 green: max(0.2, CGFloat(myAllocation - cityAllocation) * 4),
                                                 blue: 0.2, alpha: 1)
    }
    
}
