//
//  CoinStackView.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 3/28/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import UIKit

class CoinStackView : UIView {
    
    // Should have flexible width
    @IBOutlet var coinContainerView: UIView!
    @IBOutlet weak var dragDelegate: CoinsDraggableProtocol!
    
    var coinSubviews: [UIImageView] = []
    static let coinImage: UIImage = UIImage(named: "coin")!
    
    func setup(numCoins: Int) {
        // remove any existing coins on reuse
        self.coinSubviews.forEach { $0.removeFromSuperview() }
        
        let coinSize = Self.coinImage.size
        let aspectRatio = coinSize.height / coinSize.width
        let coinOffset = self.bounds.size.width * aspectRatio * 0.5
        
        self.coinSubviews = []
        for i in 0..<numCoins {
            let imageView = UIImageView(image: Self.coinImage)
            self.coinSubviews.append(imageView)
            
            self.coinContainerView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            // pin to left and center with aspect ratio
            self.coinContainerView.addConstraint(imageView.leftAnchor.constraint(equalTo: self.coinContainerView.leftAnchor))
            self.coinContainerView.addConstraint(imageView.centerXAnchor.constraint(equalTo: self.coinContainerView.centerXAnchor))
            imageView.addConstraint(imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: aspectRatio))
            
            // stack coins top-to-bottom
            self.coinContainerView.addConstraint(self.coinContainerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: CGFloat(i) * coinOffset))
        }
        
        if let lastCoin = self.coinSubviews.last {
            self.coinContainerView.addConstraint(lastCoin.topAnchor.constraint(greaterThanOrEqualTo: self.coinContainerView.topAnchor))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedCoins = self.coinSubviews.enumerated().filter { $0.element.frame.contains(touchLocation) }
        guard let touchedCoin = touchedCoins.last else {
            return
        }
        
        let touchedCoinIndex = touchedCoin.offset
        let draggedCoins = [UIImageView](self.coinSubviews[touchedCoinIndex...])
        self.dragDelegate.didBeginDragging(coins: draggedCoins, touch: touch, view: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        self.dragDelegate.didContinueDragging(touch: touch, view: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        self.dragDelegate.didEndDragging(touch: touch, view: self)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        self.dragDelegate.didCancelDragging(touch: touch, view: self)
    }
    
}
