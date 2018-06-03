//
//  DayCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/24/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

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
        dayLabel.textColor = Colors.normalCellTextColor
        
        let realm = try! Realm()
        if calendar.startOfDay(for: Date()) >= dayDate {
            if realm.objects(Log.self).filter("timestamp = \(dayDate.timeIntervalSince1970) AND mood.name = 'bleeding' AND value != 'spotting'").first != nil {
                self.backgroundColor = Colors.realPeriodCellColor // TODO change color
                self.dayLabel.textColor = Colors.realPeriodCellTextColor
            }
        } else {
            if let setup = realm.objects(Setup.self).last , let setting = realm.objects(Setting.self).last , setting.pregnantMode == 0 {
                switch Utility.forecastingDate(dayDate , setup: setup) {
                case .period:
                    self.backgroundColor = Colors.periodCellColor
                    self.dayLabel.textColor = Colors.periodCellTextColor
                    break
                case .fertile:
                    self.backgroundColor = Colors.fertileCellColor
                    self.dayLabel.textColor = Colors.fertileCellTextColor
                    break
                case .fertileDate:
                    self.backgroundColor = Colors.fertileDayCellColor
                    self.dayLabel.textColor = Colors.fertileDayCellTextColor
                    break
                case .pms:
                    self.backgroundColor = Colors.pmsCellColor
                    self.dayLabel.textColor = Colors.pmsCellTextColor
                    break
                case.normal:
                    self.backgroundColor = Colors.normalCellColor
                    self.dayLabel.textColor = Colors.normalCellTextColor
                    break
                }
            }
        }
        
        if let diffrence =  calendar.dateComponents([.day], from: Date(timeIntervalSince1970: Utility.latestPeriodLog()), to: dayDate).day , diffrence > 0 , diffrence % 7 == 0 , diffrence < 40 * 7 { // For showing first day of pregnant week
            if let setting = realm.objects(Setting.self).last , setting.pregnantMode == 1 {
                self.backgroundColor = Colors.pregnantCellColor
                self.dayLabel.textColor = Colors.pregnantCellTextColor
            }
        }
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
