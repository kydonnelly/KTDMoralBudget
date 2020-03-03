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
    @IBOutlet var iconImageViews: [UIImageView]!
    
    @IBOutlet var changeLabel: UILabel!
    @IBOutlet var upView: UIView!
    @IBOutlet var downView: UIView!
    @IBOutlet var equalView: UIView!
    
    @IBOutlet var cardView: UIView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cardView.layer.backgroundColor = UIColor(white: 0.97, alpha: 1.0).cgColor
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setup(departmentInfo: DepartmentInfo, myAllocation: Double, cityAllocation: Double) {
        let delta = Int(round(abs(myAllocation - cityAllocation) / cityAllocation * 100))
        
        for iconImageView in self.iconImageViews {
            iconImageView.image = UIImage(named: departmentInfo.iconName)
        }
        
        if (delta == 0) {
            self.titleLabel.text = departmentInfo.name
            self.detailLabel.text = "\(round(cityAllocation * 1000.0) / 10.0)%"
            
            self.changeLabel.text = "No Change"
            self.equalView.isHidden = false
            self.downView.isHidden = true
            self.upView.isHidden = true
        } else {
            self.titleLabel.text = departmentInfo.name
            self.detailLabel.text = "\(round(cityAllocation * 1000.0) / 10.0)% -> \(round(myAllocation * 1000.0) / 10.0)%"
            
            let isMore = myAllocation > cityAllocation
            let changeDescription = isMore ? "MORE" : "LESS"
            self.changeLabel.text = "\(delta)%\n\(changeDescription)"
            self.equalView.isHidden = true
            self.downView.isHidden = isMore
            self.upView.isHidden = !isMore
        }
    }
    
}
