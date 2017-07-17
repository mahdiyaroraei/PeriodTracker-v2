//
//  MoodValueCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/12/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class MoodValueCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moodImageView: UIImageView!
    
    var color: UIColor!
    var value: String!
    
    var isSelect = false
    
    var shapeLayer: CAShapeLayer! = nil
    
    func refresh() {
        
        // Icon
        moodImageView.image = UIImage(named: "smiling")?.withRenderingMode(.alwaysTemplate)
        moodImageView.tintColor = color
        
        shapeLayer = CAShapeLayer()
        let squarePath = UIBezierPath(roundedRect: CGRect(x: 7, y:7, width: self.frame.width - 14, height: self.frame.height - 14), cornerRadius: 5).cgPath
        shapeLayer.path = squarePath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.cornerRadius = 5
        shapeLayer.lineWidth = 5
        shapeLayer.strokeColor = color.cgColor
        
        self.layer.insertSublayer(shapeLayer, at: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        deselect()
        shapeLayer.removeFromSuperlayer()
        
        // Use fucking this statement for correct reload collectionview and dont use pervious layer :/
        shapeLayer = nil
    }
    
    func toggle() {
        if isSelect {
            deselect()
        }else{
            select()
        }
    }
    
    func select()  {
        isSelect = true
        shapeLayer.fillColor = color.cgColor
        moodImageView.tintColor = UIColor.white
    }
    
    func deselect()  {
        isSelect = false
        shapeLayer.fillColor = UIColor.clear.cgColor
        moodImageView.tintColor = color
    }
}
