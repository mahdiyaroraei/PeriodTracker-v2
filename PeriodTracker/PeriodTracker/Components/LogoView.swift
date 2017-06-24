//
//  LogoView.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/21/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

@IBDesignable
class LogoView: UIView {
    
    override func layoutSubviews() {
        //// Define Animation
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        /* set up animation */
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 2.25
        
        //// Color Declarations
        let color = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 44.27, y: 71.03))
        bezierPath.addCurve(to: CGPoint(x: 49.93, y: 86.96), controlPoint1: CGPoint(x: 44.27, y: 71.03), controlPoint2: CGPoint(x: 50.26, y: 77.85))
        bezierPath.addCurve(to: CGPoint(x: 37, y: 101), controlPoint1: CGPoint(x: 49.59, y: 96.07), controlPoint2: CGPoint(x: 42.92, y: 101))
        bezierPath.addCurve(to: CGPoint(x: 24.07, y: 86.96), controlPoint1: CGPoint(x: 31.07, y: 101), controlPoint2: CGPoint(x: 24.43, y: 96.16))
        bezierPath.addCurve(to: CGPoint(x: 36.73, y: 62.93), controlPoint1: CGPoint(x: 23.76, y: 79.13), controlPoint2: CGPoint(x: 29.99, y: 69.14))
        bezierPath.addCurve(to: CGPoint(x: 65.55, y: 32.97), controlPoint1: CGPoint(x: 43.23, y: 56.94), controlPoint2: CGPoint(x: 60.82, y: 42.02))
        bezierPath.addCurve(to: CGPoint(x: 67.97, y: 13.8), controlPoint1: CGPoint(x: 71.47, y: 21.63), controlPoint2: CGPoint(x: 67.97, y: 13.8))
        bezierPath.addCurve(to: CGPoint(x: 52.89, y: 3), controlPoint1: CGPoint(x: 67.97, y: 13.8), controlPoint2: CGPoint(x: 63.8, y: 3))
        bezierPath.addCurve(to: CGPoint(x: 36.73, y: 11.1), controlPoint1: CGPoint(x: 41.98, y: 3), controlPoint2: CGPoint(x: 36.73, y: 11.1))
        bezierPath.addCurve(to: CGPoint(x: 19.49, y: 3), controlPoint1: CGPoint(x: 36.73, y: 11.1), controlPoint2: CGPoint(x: 30.13, y: 3))
        bezierPath.addCurve(to: CGPoint(x: 5.48, y: 11.64), controlPoint1: CGPoint(x: 8.85, y: 3), controlPoint2: CGPoint(x: 5.48, y: 11.64))
        bezierPath.addCurve(to: CGPoint(x: 5.21, y: 30.81), controlPoint1: CGPoint(x: 5.48, y: 11.64), controlPoint2: CGPoint(x: 0.36, y: 18.39))
        bezierPath.addCurve(to: CGPoint(x: 36.73, y: 62.93), controlPoint1: CGPoint(x: 10.06, y: 43.23), controlPoint2: CGPoint(x: 36.73, y: 62.93))
        color.setStroke()
        bezierPath.lineWidth = 6
        bezierPath.lineCapStyle = .round
        bezierPath.stroke()
        
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 6.0
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.path = bezierPath.cgPath
        
        shapeLayer.add(animation, forKey: "drawLineAnimation")
        
        self.layer.addSublayer(shapeLayer)
        

    }
}
