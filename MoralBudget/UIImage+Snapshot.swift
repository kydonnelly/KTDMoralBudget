//
//  UIImage+Snapshot.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 3/28/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import UIKit

extension UIImage {
    
    public static func snapshot(views: [UIView]) -> UIImage? {
        let fullFrame = views.frame
        UIGraphicsBeginImageContextWithOptions(fullFrame.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        for view in views {
            // Draw at the view's Y, and then reset to avoid accumulation
            context.translateBy(x: 0, y: view.frame.origin.y - fullFrame.origin.y)
            view.layer.render(in: context)
            context.translateBy(x: 0, y: fullFrame.origin.y - view.frame.origin.y)
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

extension Array where Element: UIView {
    
    public var frame: CGRect {
        guard !self.isEmpty else {
            return CGRect.null
        }
        
        let frames = self.map { $0.frame }
        let minX = frames.map { $0.origin.x }.min()!
        let maxX = frames.map { $0.origin.x + $0.size.width }.max()!
        let minY = frames.map { $0.origin.y }.min()!
        let maxY = frames.map { $0.origin.y + $0.size.height }.max()!
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
}
