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
    @IBOutlet var detailLabel: UILabel!
    
    func setup(departmentInfo: DepartmentInfo, myAllocation: Double, cityAllocation: Double) {
        let delta = Int(round(abs(myAllocation - cityAllocation) / cityAllocation * 100))
        
        if (delta == 0) {
            self.titleLabel.text = "\(departmentInfo.name): No Change"
            self.detailLabel.text = "\(round(cityAllocation * 1000.0) / 10.0)%"
        } else {
            let direction = myAllocation > cityAllocation ? "More" : "Less"
            self.titleLabel.text = "\(departmentInfo.name): \(delta)% \(direction)"
            self.detailLabel.text = "\(round(cityAllocation * 1000.0) / 10.0)% -> \(round(myAllocation * 1000.0) / 10.0)%"
        }
        
        // scale from green at 50% to red at -50%
        self.detailLabel.textColor = UIColor(red: 0.2 + CGFloat(cityAllocation - myAllocation) * 4,
                                             green: 0.2 + CGFloat(myAllocation - cityAllocation) * 4,
                                             blue: 0.2, alpha: 1)
    }
    
}
