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
    
    @IBOutlet var percentageField: UITextField!
    
    @IBOutlet var expandedTouchView: UIView!
    
    public typealias UpdateBlock = ((_ value: Double) -> Void)
    private var updateBlock: UpdateBlock? = nil
    
    public typealias TouchUpBlock = (() -> Void)
    private var touchUpBlock: TouchUpBlock? = nil
    
    func setup(title: String, subtitle: String, initialValue: Double, updateBlock: UpdateBlock? = nil, touchUpBlock: TouchUpBlock? = nil) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        
        self.sliderView.value = Float(initialValue)
        self.update(value: initialValue)
        
        self.updateBlock = updateBlock
        self.touchUpBlock = touchUpBlock
    }
    
    @IBAction func sliderValueChanged(_ slider: UISlider) {
        let value = Double(slider.value)
        
        self.update(value: value)
    }
    
    @IBAction func sliderFinishedSliding(_ slider: UISlider) {
        self.touchUpBlock?()
    }
    
    private func update(value: Double) {
        self.percentageField.text = "\(round(value * 1000) / 10)"
        self.updateBlock?(value)
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

extension DepartmentSliderCell : UITextFieldDelegate {
    
    private func submit(_ textField: UITextField) {
        guard let doubleText = textField.text, let inputValue = Double(doubleText) else {
            return
        }
        
        let value = inputValue / 100.0
        self.update(value: value)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.submit(textField)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.submit(textField)
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let inputText = textField.text else {
            return false
        }
        
        let validSet = CharacterSet(charactersIn: "0123456789.")
        let inputSet = CharacterSet(charactersIn: inputText)
        
        return validSet.isSuperset(of: inputSet)
    }
    
}
