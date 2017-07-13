//
//  MoodValueCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/12/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class MoodValueCollectionViewCell: UICollectionViewCell {
    
    var color: UIColor!
    var value: String!
    
    let shapeLayer = CAShapeLayer()
    
    func refresh() {
        shapeLayer.removeFromSuperlayer()
        
        let squarePath = UIBezierPath(roundedRect: CGRect(x: 7, y:7, width: self.frame.width - 14, height: self.frame.height - 14), cornerRadius: 5).cgPath
        shapeLayer.path = squarePath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.cornerRadius = 5
        shapeLayer.lineWidth = 5
        shapeLayer.strokeColor = color.cgColor
        
        self.layer.insertSublayer(shapeLayer, at: 0)
    }
}
