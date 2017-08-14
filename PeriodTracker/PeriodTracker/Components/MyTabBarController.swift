//
//  MyTabBarController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/8/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class MyTabBarController: UITabBarController {
    
    public static var instance: MyTabBarController!
    
    var controllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imageNames: [String] = ["tab-calendar", "tab-setting", "tab-article"]
        var tabTitles: [String] = ["تقویم", "تنظیمات", "مقالات"]
        
        MyTabBarController.instance = self
        
        controllers.removeAll()
        
        controllers.append((self.storyboard?.instantiateViewController(withIdentifier: "calendarViewController"))!)
        controllers.append((self.storyboard?.instantiateViewController(withIdentifier: "settingViewController"))!)
        controllers.append((self.storyboard?.instantiateViewController(withIdentifier: "articlesViewController"))!)
        
        var pregnantEnable = false
        let realm = try! Realm()
        if let setting = realm.objects(Setting.self).last {
            if setting.pregnantMode == 1 {
                pregnantEnable = true
            }
        }
        if pregnantEnable {
            imageNames.insert("tab-pregnant", at: 1)
            tabTitles.insert("بارداری", at: 1)
            controllers.insert((self.storyboard?.instantiateViewController(withIdentifier: "pregnantViewController"))!, at: 1)
        } else {
            imageNames.insert("tab-cycle", at: 1)
            tabTitles.insert("دوره", at: 1)
            controllers.insert((self.storyboard?.instantiateViewController(withIdentifier: "cycleViewController"))!, at: 1)
        }
        
        viewControllers = controllers
        tabBar.tintColor = UIColor.uicolorFromHex(rgbValue: 0x7ca013)
        tabBar.unselectedItemTintColor = UIColor.uicolorFromHex(rgbValue: 0x36454a)
        for (index , tabBar) in tabBar.items!.enumerated() {
            tabBar.image = UIImage(named: imageNames[index])
            tabBar.title = tabTitles[index]
            tabBar.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "IRANSansFaNum-Medium", size: 9)! , NSForegroundColorAttributeName: UIColor.uicolorFromHex(rgbValue: 0x36454a)], for: .normal)
            tabBar.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "IRANSansFaNum-Medium", size: 11)! , NSForegroundColorAttributeName: UIColor.uicolorFromHex(rgbValue: 0x7ca013)], for: .selected)
        }
    }

}
