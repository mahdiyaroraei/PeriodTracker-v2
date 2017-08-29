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
import UserNotifications

enum DayType {
    case fertile
    case fertileDate
    case period
    case pms
    case normal
}

class Utility: NSObject, UITextViewDelegate {
    
    static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func translate(key: String) -> String? {
        return translate(to: Config.Locale, key: key)
    }
    
    static func translate(to: String , key: String) -> String? {
        if let path = Bundle.main.path(forResource: "translate-\(to)", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: String] {
                return dic[key]!
            }
        }
        return nil
    }
    
    static func createGuideObjectFromKey(key: String) -> Guide? {
        var items: [Item] = []
        
        if let path = Bundle.main.path(forResource: "Guide", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: String] {
                let parsedItem = JSON(dic[key]!.data(using: .utf8)!)
                for itemJson in parsedItem.array! {
                    if itemJson["type"].string! == ItemType.AttributeText.rawValue {
                        var attributes: [TextAttribute] = []
                        for jsonAttribute in itemJson["attributes"].array! {
                            attributes.append(TextAttribute(key: jsonAttribute["key"].string!, value: jsonAttribute["value"].string, range: jsonAttribute["range"].string))
                        }
                        let textItem = Item(text: itemJson["text"].string!, attributes: attributes , link: itemJson["link"].string)
                        items.append(textItem)
                    } else if itemJson["type"].string! == ItemType.Image.rawValue {
                        var images: [Image] = []
                        for jsonAttribute in itemJson["images"].array! {
                            images.append(Image(imageURL: jsonAttribute["imageURL"].string!, link: jsonAttribute["link"].string, aspectRatio: jsonAttribute["aspect_ratio"].float))
                        }
                        let imageItem = Item(images: images)
                        items.append(imageItem)
                    }
                }
                return Guide(key: key, content: items)
            }
        }
        return nil
    }
    
    static func setLocalPushForEnableNotices(withCompletionHandler: ((Error?) -> Void)?) {
        
        let realm = try! Realm()
        
        if #available(iOS 10.0, *) {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removeAllPendingNotificationRequests()
        } else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
        
        if let setting = realm.objects(Setting.self).last , setting.pregnantMode == 0 {
            if let setup = realm.objects(Setup.self).last {
                if setup.startDate == 0 || setup.cycleLength == 0 || setup.periodLength == 0 {
                    return
                }
                if setting.fertileNotice == 1 {
                    
                    let date = Utility.nextFertileDate(Date(), setup: try! Realm().objects(Setup.self).last!)
                    let title = "Period"
                    let body = "Don't forget"
                    
                    if #available(iOS 10.0, *) {
                        sendLocalPushiOS10(date: date, title: title, body: body , identifier: "PeriodLocalNotification", withCompletionHandler: withCompletionHandler)
                    } else {
                        sendLocalPushBellowiOS10(date: date, title: title, body: body)
                    }
                    
                }
                
                if setting.priodNotice == 1 {
                    
                    let date = Utility.nextPeriodDate(Date(), setup: try! Realm().objects(Setup.self).last!)
                    let title = "Fertile"
                    let body = "Don't forget"
                    
                    if #available(iOS 10.0, *) {
                        sendLocalPushiOS10(date: date, title: title, body: body , identifier: "FertileLocalNotification", withCompletionHandler: withCompletionHandler)
                    } else {
                        sendLocalPushBellowiOS10(date: date, title: title, body: body)
                    }
                }
            }
        }
    }
    
    static func sendLocalPushiOS10(date: Date , title: String , body: String , identifier: String, withCompletionHandler: ((Error?) -> Void)? ) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert , .sound]) { (granted, error) in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default()
                
                let date = date
                let triggerDate = Calendar.current.dateComponents([.year,.month,.day], from: date)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                            repeats: false)
                
                let identifier = identifier
                let request = UNNotificationRequest(identifier: identifier,
                                                    content: content, trigger: trigger)
                notificationCenter.add(request, withCompletionHandler: withCompletionHandler)
            } else {
                withCompletionHandler!(error)
            }
        }
    }
    
    static func sendLocalPushBellowiOS10(date: Date , title: String , body: String) {
        
        let notificationSettings = UIUserNotificationSettings(types: [.alert , .sound] , categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        let notification = UILocalNotification()
        notification.fireDate = date
        notification.alertTitle = title
        notification.alertBody = body
        
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    static func createArticleFromJSON(_ json: JSON) -> Article {
        var access = "free"
        if let jsonAccess = json["access"].string , jsonAccess != "" {
            access = jsonAccess
        }
        
        let article = Article(id: Int(json["id"].string!)!, title: json["title"].string, addedtime: json["addedtime"].string, view: Int(json["view"].string!)!, clap: Int(json["clap"].string!)!, desc: json["desc"].string, image: json["image"].string, content: [], creator_name: json["creator_name"].string, article_read_time: json["article_read_time"].string, access: access, comment_count: json["comment_count"].int!)
        
        return article
    }
    
    static func createContentFromJSON(_ json: JSON) -> [Item] {
        
        var items: [Item] = []
        let parsedItem = JSON(json["content"].string!.data(using: .utf8)!)
        for itemJson in parsedItem.array! {
            if itemJson["type"].string! == ItemType.AttributeText.rawValue {
                var attributes: [TextAttribute] = []
                for jsonAttribute in itemJson["attributes"].array! {
                    attributes.append(TextAttribute(key: jsonAttribute["key"].string!, value: jsonAttribute["value"].string, range: jsonAttribute["range"].string))
                }
                let textItem = Item(text: itemJson["text"].string!, attributes: attributes , link: itemJson["link"].string)
                items.append(textItem)
            } else if itemJson["type"].string! == ItemType.Image.rawValue {
                var images: [Image] = []
                for jsonAttribute in itemJson["images"].array! {
                    images.append(Image(imageURL: jsonAttribute["imageURL"].string!, link: jsonAttribute["link"].string, aspectRatio: jsonAttribute["aspect_ratio"].float))
                }
                let imageItem = Item(images: images)
                items.append(imageItem)
            }
        }
        
        return items
    }
    
    static func nextPeriodDate(_ date: Date , setup: Setup) -> Date {
        
        let cycleLength = setup.cycleLength
        
        let calendar = Calendar(identifier: .persian)
        let diffrence = calendar.dateComponents([.day], from: Date(timeIntervalSince1970: setup.startDate), to: date).day!
        let remain = diffrence % cycleLength
        if remain == 0 { // Start of period
            return date
        } else if computeFertileRange(cycleLength).contains(remain) {
            return nextPeriodDate(calendar.date(byAdding: .day, value: 1, to: date)!, setup: setup)
        } else if cycleLength - remain < 4 {
            return nextPeriodDate(calendar.date(byAdding: .day, value: 1, to: date)!, setup: setup)
        } else {
            return nextPeriodDate(calendar.date(byAdding: .day, value: 1, to: date)!, setup: setup)
        }
    }
    
    static func nextFertileDate(_ date: Date , setup: Setup) -> Date {
        
        let cycleLength = setup.cycleLength
        
        let calendar = Calendar(identifier: .persian)
        let diffrence = calendar.dateComponents([.day], from: Date(timeIntervalSince1970: setup.startDate), to: date).day!
        let remain = diffrence % cycleLength
        if computeFertileRange(cycleLength).first! == remain { // Start of fertile
            return date
        } else if cycleLength - remain < 4 {
            return nextFertileDate(calendar.date(byAdding: .day, value: 1, to: date)!, setup: setup)
        } else {
            return nextFertileDate(calendar.date(byAdding: .day, value: 1, to: date)!, setup: setup)
        }
    }
    
    static func forecastingDate(_ date: Date , setup: Setup) -> DayType {
        
        let cycleLength = setup.cycleLength
        
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
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: link)!, options: [:]) { (finish) in
                
            }
        } else {
            UIApplication.shared.openURL(URL(string: link)!)
        }
    }
    
    static func createAttributeTextFromTextItem(textItem: Item) -> NSMutableAttributedString {
        let text = textItem.text
        let attributeText = NSMutableAttributedString(string: text!)
        
        if let attributes = textItem.attributes {
            for attribute in attributes {
                let range = attribute.range == nil ? NSRange(location: 0, length: text!.characters.count) : attribute.range!
                if attribute.key == "font" {
                    if let font = attribute.value , font.components(separatedBy: "@").count > 1 {
                        // font has font size
                        attributeText.addAttribute(NSFontAttributeName, value: UIFont(name:font.components(separatedBy: "@")[0], size: CGFloat(Int(font.components(separatedBy: "@")[1])!))!, range: range)
                    } else {
                        attributeText.addAttribute(NSFontAttributeName, value: UIFont(name: attribute.value!, size: 15)!, range: range)
                    }
                } else if attribute.key == "text_alignment" {
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.lineSpacing = 5
                    if attribute.value! == "left" {
                        paragraph.alignment = .left
                    } else if attribute.value! == "center" {
                        paragraph.alignment = .center
                    } else if attribute.value! == "right" {
                        paragraph.alignment = .right
                        
//                        attributeText.addAttribute(NSKernAttributeName, value: 0.5, range: range)
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
        
        let result = realm.objects(Log.self).filter("mood.name == 'bleeding' AND value != 'spotting'").sorted(byKeyPath: "timestamp", ascending: false)
        
        var timestamp: Double = 0
        for log in result {
            if timestamp == 0 {
                timestamp = log.timestamp
            } else {
                if Calendar.current.dateComponents([.day], from: Date(timeIntervalSince1970: log.timestamp), to: Date(timeIntervalSince1970: timestamp)).day! == 1 {
                    timestamp = log.timestamp
                } else {
                    break
                }
            }
        }
        
        return timestamp
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
    
    
    static func timeAgoSinceFromNow(_ date: Date) -> String {
        
        let calendar = Calendar(identifier: .persian)
        let now = Date()
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
        
        if let day = components.day , day == 0 {
            return "امروز"
        }
        
        let dateComponents = calendar.dateComponents([.year , .month , .day], from: date)
        return "\(dateComponents.year!)/\(dateComponents.month!)/\(dateComponents.day!)"
        
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
        
        if let day = components.day , day == 0 {
            return "همین الان"
        }
        
        let dateComponents = calendar.dateComponents([.year , .month , .day], from: date)
        return "\(dateComponents.year!)/\(dateComponents.month!)/\(dateComponents.day!)"
        
    }
    
    static func persianDate(from date: Date) -> String {
        var persianDateString = ""
        
        let calendar = Calendar(identifier: .persian)
        let dateComponenets = calendar.dateComponents([.year , .month , .day], from: date)
        persianDateString = "\(dateComponenets.year!)/\(dateComponenets.month!)/\(dateComponenets.day!)"
        
        return persianDateString
    }
}
