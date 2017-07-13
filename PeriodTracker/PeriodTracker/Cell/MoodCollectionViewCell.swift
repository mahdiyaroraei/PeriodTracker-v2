//
//  MoodCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/6/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class MoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moodImageView: UIImageView!
    let circleShape = CAShapeLayer()
    let strokeShape = CAShapeLayer()
    
    var color: UIColor!
    var name: String!
    
    func refresh() {
        
        // Icon
        moodImageView.image = UIImage(named: "smiling")?.withRenderingMode(.alwaysTemplate)
        moodImageView.tintColor = color
        
        // Draw circle arround cell
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.width / 2) , radius: self.frame.size.width / 2 - 10 , startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        circleShape.path = circlePath.cgPath
        circleShape.fillColor = UIColor.white.cgColor
        circleShape.strokeColor = color.cgColor
        circleShape.lineWidth = 8
        
        self.layer.insertSublayer(circleShape, at: 0)
    }
    
    func select() {
        // Draw dash circle for selected item
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.width / 2) , radius: self.frame.size.width / 2 - 2 , startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        strokeShape.path = circlePath.cgPath
        strokeShape.fillColor = UIColor.clear.cgColor
        strokeShape.strokeColor = color.cgColor
        strokeShape.lineWidth = 2
        strokeShape.lineDashPattern = [2,3]
        
        self.layer.insertSublayer(strokeShape, at: 0)
        
        // Fill circle
//        circleShape.fillColor = color.cgColor
        
        // Change icon tint color to white
//        moodImageView.tintColor = UIColor.white
    }
    
    func deselect() {
        strokeShape.removeFromSuperlayer()
    }
    
}
