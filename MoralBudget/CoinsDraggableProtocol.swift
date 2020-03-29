//
//  CoinsDraggableProtocol.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 3/28/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import UIKit

@objc protocol CoinsDraggableProtocol: class {
    
    func didBeginDragging(coins: [UIImageView], touch: UITouch, view: UIView)
    func didContinueDragging(touch: UITouch, view: UIView)
    func didCancelDragging(touch: UITouch, view: UIView)
    func didEndDragging(touch: UITouch, view: UIView)
    
}
