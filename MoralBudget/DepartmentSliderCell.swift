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
    @IBOutlet var expandedTouchView: UIView!

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    @IBOutlet var lockButton: UIButton!
    @IBOutlet var percentageField: UITextField!
    
    @IBOutlet var gradientView: LinearGradientView!
    
    public typealias UpdateBlock = ((_ value: Double) -> Void)
    private var updateBlock: UpdateBlock? = nil
    
    public typealias TouchUpBlock = (() -> Void)
    private var touchUpBlock: TouchUpBlock? = nil
    
    public typealias LockBlock = ((Bool) -> Bool)
    private var lockBlock: LockBlock? = nil
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.iconImageView.iconColor = UIColor(hexValue: 0x191919, alpha: 1.0)
    }
    
    func setup(departmentInfo: DepartmentInfo, initialValue: Double, isLocked: Bool, updateBlock: UpdateBlock? = nil, lockBlock: LockBlock? = nil, touchUpBlock: TouchUpBlock? = nil) {
        self.titleLabel.text = departmentInfo.name
        
        self.iconImageView.setIcon(name: departmentInfo.iconName)
        self.sliderView.tintColor = departmentInfo.iconColor
        self.gradientView.update(colors: [UIColor(hexString: departmentInfo.hexColor, alpha: 0.75),
                                          UIColor(hexString: departmentInfo.hexColor, alpha: 0.60),
                                          UIColor(hexString: departmentInfo.hexColor, alpha: 0.15),
                                          UIColor(hexString: departmentInfo.hexColor, alpha: 0.0)],
                                 direction: .horizontal)
        
        self.refresh(value: initialValue)
        self.refresh(isLocked: isLocked)
        
        self.lockBlock = lockBlock
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
    
    @IBAction func didTapLockButton(_ button: UIButton) {
        let isLocked = !button.isSelected
        
        if self.lockBlock?(isLocked) == true {
            self.refresh(isLocked: isLocked)
        }
    }
    
    private func refresh(isLocked: Bool) {
        self.lockButton.isSelected = isLocked
        
        if isLocked {
            self.lockButton.tintColor = UIColor(hexValue: 0x32A632, alpha: 1.0)
        } else {
            self.lockButton.tintColor = UIColor(white: 0.33, alpha: 0.2)
        }
    }
    
    private func refresh(value: Double) {
        self.sliderView.value = Float(value)
        self.percentageField.text = "\(round(value * 1000) / 10)"
    }
    
    private func update(value: Double) {
        self.refresh(value: value)
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
        self.touchUpBlock?()
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Show the original value, but don't make user backspace through it
        textField.placeholder = textField.text
        textField.text = ""
        
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        // Revert change from textFieldShouldBeginEditing
        if textField.text == "" {
            textField.text = textField.placeholder
        }
        
        self.submit(textField)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
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
