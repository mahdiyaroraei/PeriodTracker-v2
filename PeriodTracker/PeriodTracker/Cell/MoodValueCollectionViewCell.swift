//
//  MoodValueCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/12/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class MoodValueCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moodImageView: UIImageView!
    
    var color: UIColor!
    var value: String!
    
    var isSelect = false
    
    var shapeLayer: CAShapeLayer! = nil
    
    let realm = try! Realm()
    
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
        
        let timestamp = Calendar.current.startOfDay(for: CalendarViewController.selectedDate!).timeIntervalSince1970
        isSelect = realm.objects(Log.self).filter("timestamp == \(timestamp) AND value = '\(value!)'").count > 0
        if isSelect {
            self.isSelected = true
            shapeLayer.fillColor = color.cgColor
            moodImageView.tintColor = UIColor.white
        }else{
            shapeLayer.fillColor = UIColor.clear.cgColor
            moodImageView.tintColor = color
        }
        
        self.layer.insertSublayer(shapeLayer, at: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        shapeLayer.removeFromSuperlayer()
        
        // Use fucking this statement for correct reload collectionview and dont use pervious layer :/
        shapeLayer = nil
    }
    
    func toggle(mood: Mood) {
        if isSelect {
            deselect(mood: mood)
        }else{
            select(mood: mood)
        }
    }
    
    func select(mood: Mood)  {
        isSelect = true
        shapeLayer.fillColor = color.cgColor
        moodImageView.tintColor = UIColor.white
        
        let timestamp = Calendar.current.startOfDay(for: CalendarViewController.selectedDate!).timeIntervalSince1970
        
        guard let log: Log = realm.objects(Log.self).filter("timestamp == \(timestamp) AND value CONTAINS '\(value!)'").first else {
            
            let log = Log()
            log.timestamp = timestamp
            log.mood = mood
            log.value = value!
            
            try! realm.write {
                realm.add(log)
            }
            
            return
        }
        
        // If log exist and multiselection enabled value save like array and seperate by ,
        try! realm.write {
            log.value += ",\(value!)"
        }
    }
    
    func deselect(mood: Mood)  {
        isSelect = false
        shapeLayer.fillColor = UIColor.clear.cgColor
        moodImageView.tintColor = color
        
        let timestamp = Calendar.current.startOfDay(for: CalendarViewController.selectedDate!).timeIntervalSince1970
        
        guard let log: Log = realm.objects(Log.self).filter("timestamp == \(timestamp) AND value CONTAINS '\(value!)'").first else {
            return
        }
        
        // if only this value saved delete row if not update it
        if log.value == value! {
            try! realm.write {
                realm.delete(log)
            }
        }else{
            let values = log.value.components(separatedBy: ",")
            var editedValues: String = ""
            for val in values {
                if val != value! {
                    editedValues += ",\(val)"
                }
            }
            // remove first ,
            editedValues.remove(at: editedValues.startIndex)
            try! realm.write {
                log.value = editedValues
            }
        }
        
    }
}
