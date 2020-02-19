//
//  DepartmentSliderView.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 2/15/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import UIKit

public class DepartmentSliderCell : UITableViewCell {
    
    @IBOutlet var sliderView: UISlider!

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var percentageLabel: UILabel!
    
    @IBOutlet var expandedTouchView: UIView!
    
    public typealias UpdateBlock = ((_ value: Double) -> Void)
    private var updateBlock: UpdateBlock? = nil
    
    public typealias TouchUpBlock = (() -> Void)
    private var touchUpBlock: TouchUpBlock? = nil
    
    func setup(title: String, subtitle: String, initialValue: Double, updateBlock: UpdateBlock? = nil, touchUpBlock: TouchUpBlock? = nil) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        
        self.sliderView.value = Float(initialValue)
        self.refresh(value: initialValue)
        
        self.updateBlock = updateBlock
        self.touchUpBlock = touchUpBlock
    }
    
    @IBAction func sliderValueChanged(_ slider: UISlider) {
        let value = Double(slider.value)
        
        self.refresh(value: value)
        self.updateBlock?(value)
    }
    
    @IBAction func sliderFinishedSliding(_ slider: UISlider) {
        self.touchUpBlock?()
    }
    
    private func refresh(value: Double) {
        self.percentageLabel.text = "\(round(value * 1000) / 10)%"
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if hitView == self.expandedTouchView {
            return self.sliderView
        } else {
            return hitView
        }
    }
    
}
