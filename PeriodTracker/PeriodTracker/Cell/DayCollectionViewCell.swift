//
//  DayCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/24/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    
    var dayDate: Date!
    var calendar = Calendar(identifier: .persian)
    
    // Select layer
    var fillLayer: CAShapeLayer?
    
    func refresh() {
        let dateComponents = calendar.dateComponents([.day], from: dayDate)
        dayLabel.text = "\(String(describing: dateComponents.day!))"
        self.backgroundColor = Colors.normalCellColor
        
    }
    
    func empty() {
        dayDate = nil
        backgroundColor = UIColor.white
        dayLabel.text = ""
    }
    
    func select() {
        dayLabel.textColor = UIColor.white
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.width / 2), radius: self.frame.size.width / 2, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        fillLayer = CAShapeLayer()
        fillLayer?.path = circlePath.cgPath
        
        //change the fill color
        fillLayer?.fillColor = Colors.accentColor.cgColor
        //you can change the stroke color
        fillLayer?.strokeColor = Colors.accentColor.cgColor
        //you can change the line width
        fillLayer?.lineWidth = 3.0
        
        // add to collection layer for draw on top of cell
        self.layer.insertSublayer(fillLayer!, at: 0)
    }
    
    func deSelect() {
        if fillLayer != nil {
            dayLabel.textColor = Colors.normalCellTextColor
            fillLayer!.removeFromSuperlayer()
        }
    }
}
