//
//  Utility.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 5/7/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    static func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    static func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar(identifier: .persian)
        let now = calendar.startOfDay(for: Date())
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) سال قبل"
        }
        
        if let year = components.year, year >= 1 {
            return "سال قبل"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) ماه پیش"
        }
        
        if let month = components.month, month >= 1 {
            return "ماه قبل"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) هفته پیش"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "هفته قبل"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) روز پیش"
        }
        
        if let day = components.day, day >= 1 {
            return "دیروز"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) ساعت پیش"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "یک ساعت پیش"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) دقیقه پیش"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "یک دقیقه پیش"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) ثانیه پیش"
        }
        
        return "امروز"
        
    }
}
