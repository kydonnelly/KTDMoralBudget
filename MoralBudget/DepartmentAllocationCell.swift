//
//  DepartmentAllocationCell.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 2/17/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import UIKit

public class DepartmentAllocationCell : UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    @IBOutlet var changeLabel: UILabel!
    @IBOutlet var upArrow: UIImageView!
    @IBOutlet var downArrow: UIImageView!
    @IBOutlet var equalArrow: UIImageView!
    
    @IBOutlet var cardView: UIView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cardView.layer.backgroundColor = UIColor(white: 0.97, alpha: 1.0).cgColor
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setup(departmentInfo: DepartmentInfo, myAllocation: Double, cityAllocation: Double) {
        let delta = Int(round(abs(myAllocation - cityAllocation) / cityAllocation * 100))
        
        if (delta == 0) {
            self.titleLabel.text = departmentInfo.name
            self.detailLabel.text = "\(round(cityAllocation * 1000.0) / 10.0)%"
            
            self.changeLabel.text = "No Change"
            self.equalArrow.isHidden = false
            self.downArrow.isHidden = true
            self.upArrow.isHidden = true
        } else {
            self.titleLabel.text = departmentInfo.name
            self.detailLabel.text = "\(round(cityAllocation * 1000.0) / 10.0)% -> \(round(myAllocation * 1000.0) / 10.0)%"
            
            let isMore = myAllocation > cityAllocation
            let changeDescription = isMore ? "MORE" : "LESS"
            self.changeLabel.text = "\(delta)%\n\(changeDescription)"
            self.equalArrow.isHidden = true
            self.downArrow.isHidden = isMore
            self.upArrow.isHidden = !isMore
        }
    }
    
}
