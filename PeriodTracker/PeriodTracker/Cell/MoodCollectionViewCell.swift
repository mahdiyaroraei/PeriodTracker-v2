//
//  MoodCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/6/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class MoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moodImageView: UIImageView!
    var circleShape: CAShapeLayer! = nil
    var strokeShape: CAShapeLayer! = nil
    
    var color: UIColor!
    var name: String!
    var mood: Mood!
    
    func refresh() {
        circleShape = CAShapeLayer()
        strokeShape = CAShapeLayer()
        
        // Icon
        moodImageView.image = UIImage(named: "smiling")?.withRenderingMode(.alwaysTemplate)
        moodImageView.tintColor = color
        
        // Draw circle arround cell
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.width / 2) , radius: self.frame.size.width / 2 - 10 , startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        circleShape.path = circlePath.cgPath
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.strokeColor = color.cgColor
        circleShape.lineWidth = 8
        
        // If has a log for mood fill mood circle
        let realm = try! Realm()
        let timestamp = Calendar.current.startOfDay(for: CalendarViewController.selectedDate!).timeIntervalSince1970
        let logs = realm.objects(Log.self).filter("timestamp == \(timestamp)")
        var logExist = false
        for log in logs {
            if mood.value_type.contains(log.value) {
                logExist = true
                break
            }else if mood.value_type == "float" && Float(log.value) != nil{
                logExist = true
                break
            }else if mood.value_type == "array" && log.value.contains("["){
                logExist = true
                break
            }
        }
        hasLog(logExist)
        
        self.layer.insertSublayer(circleShape, at: 0)
    }
    
    override func prepareForReuse() {
        circleShape.removeFromSuperlayer()
        strokeShape.removeFromSuperlayer()
        
        circleShape = nil
        strokeShape = nil
    }
    
    func hasLog(_ hasLog: Bool) {
        if hasLog {
            circleShape.fillColor = color.cgColor
            moodImageView.tintColor = UIColor.white
        }else{
            circleShape.fillColor = UIColor.clear.cgColor
            moodImageView.tintColor = color
        }
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
