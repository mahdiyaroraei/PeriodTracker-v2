//
//  Extensions.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/1/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        let border = CAShapeLayer()
        border.path = path.cgPath
        border.fillColor = UIColor.clear.cgColor
        border.lineWidth = 3
        border.strokeColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(border)
    }
}
