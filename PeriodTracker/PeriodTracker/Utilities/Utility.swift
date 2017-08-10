//
//  Utility.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 5/7/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

enum DayType {
    case fertile
    case fertileDate
    case period
    case pms
    case normal
}

class Utility: NSObject, UITextViewDelegate {
    
    static func createArticleFromJSON(_ json: JSON) -> Article {
        
        var items: [Item] = []
        let parsedItem = JSON(json["content"].string!.data(using: .utf8)!)
        for itemJson in parsedItem.array! {
            if itemJson["type"].string! == ItemType.AttributeText.rawValue {
                var attributes: [TextAttribute] = []
                for jsonAttribute in itemJson["attributes"].array! {
                    attributes.append(TextAttribute(key: jsonAttribute["key"].string!, value: jsonAttribute["value"].string, range: jsonAttribute["range"].string))
                }
                let textItem = Item(text: itemJson["text"].string!, attributes: attributes)
                items.append(textItem)
            } else if itemJson["type"].string! == ItemType.Image.rawValue {
                var images: [Image] = []
                for jsonAttribute in itemJson["images"].array! {
                    images.append(Image(imageURL: jsonAttribute["imageURL"].string!, link: jsonAttribute["link"].string))
                }
                let imageItem = Item(images: images)
                items.append(imageItem)
            }
        }
        
        let article = Article(id: json["id"].int, title: json["title"].string, addedtime: json["addedtime"].string, view: json["view"].int, clap: json["clap"].int, desc: json["desc"].string, image: json["image"].string, content: items, creator_name: json["creator_name"].string, article_read_time: json["article_read_time"].string)
        
        return article
    }
    
    static func forecastingDate(_ date: Date , setup: Setup) -> DayType {
        let cycleLength = 40
        let calendar = Calendar(identifier: .persian)
        let diffrence = calendar.dateComponents([.day], from: Date(timeIntervalSince1970: setup.startDate), to: date).day!
        let remain = diffrence % cycleLength
        if remain < setup.periodLength {
            return .period
        } else if computeFertileRange(cycleLength).contains(remain) {
            let fertileRange = computeFertileRange(cycleLength)
            let fertileDay = Int(ceil(Double((fertileRange.max()! + fertileRange.min()!) / 2))) - 1
            if remain == fertileDay {
                return .fertileDate
            }
            return .fertile
        } else if cycleLength - remain < 4 {
            return .pms
        } else {
            return .normal
        }
    }
    
    static func openLinkInSafari(link: String) {
        UIApplication.shared.open(URL(string: link)!, options: [:]) { (finish) in
            
        }
    }
    
    static func createAttributeTextFromTextItem(textItem: Item) -> NSMutableAttributedString {
        let text = textItem.text
        let attributeText = NSMutableAttributedString(string: text!)
        
        if let attributes = textItem.attributes {
            for attribute in attributes {
                let range = attribute.range == nil ? NSRange(location: 0, length: text!.characters.count) : attribute.range!
                if attribute.key == "font" {
                    attributeText.addAttribute(NSFontAttributeName, value: UIFont(name: attribute.value!, size: 15)!, range: range)
                } else if attribute.key == "text_alignment" {
                    let paragraph = NSMutableParagraphStyle()
                    if attribute.value! == "left" {
                        paragraph.alignment = .left
                    } else if attribute.value! == "center" {
                        paragraph.alignment = .center
                    } else if attribute.value! == "right" {
                        paragraph.alignment = .right
                    }
                    attributeText.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: range)
                } else if attribute.key == "text_color" {
                    attributeText.addAttribute(NSForegroundColorAttributeName, value: UIColor.uicolorFromHex(rgbValue: UInt32(attribute.value! , radix: 16)!), range: range)
                } else if attribute.key == "link" {
                    attributeText.addAttribute(NSLinkAttributeName, value: attribute.value!, range: range)
                    attributeText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
                    attributeText.addAttribute(NSUnderlineColorAttributeName, value: UIColor.blue , range: range) // TODO change blue
                    
                } else if attribute.key == "font" {
                    
                } else if attribute.key == "font" {
                    
                } else if attribute.key == "font" {
                    
                } else if attribute.key == "font" {
                    
                } else if attribute.key == "font" {
                    
                } else if attribute.key == "font" {
                    
                } else if attribute.key == "font" {
                    
                }
            }
        }
        return attributeText
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        Utility.openLinkInSafari(link: URL.absoluteString)
        return false
    }
    
    static func latestPeriodLog() -> Double{
        let realm = try! Realm()
        
        if let log = realm.objects(Log.self).filter("mood.name == 'bleeding' AND value != 'spotting'").last {
            return log.timestamp
        }else{
            return 0
        }
    }
    
    static func computeFertileRange(_ cycleLength: Int) -> CountableClosedRange<Int> {
        // Based on https://periodtracker.slack.com/files/oraei.mossi/F6FGYMC66/wila3140.f3.jpg compute percentage above 50
        var min = 0 , max = 0
        if cycleLength < 28 {
            min = 8
            max = 15
        }else if cycleLength == 28{
            min = 9
            max = 16
        }else if cycleLength == 29{
            min = 10
            max = 18
        }else if cycleLength >= 30{
            min = 12
            max = 20
        }
        return min...max
    }
    
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
