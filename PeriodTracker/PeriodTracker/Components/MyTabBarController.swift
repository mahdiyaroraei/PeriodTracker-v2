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
            controllers.insert((self.storyboard?.instantiateViewController(withIdentifier: "pregnantViewController"))!, at: 1)
        } else {
            controllers.insert((self.storyboard?.instantiateViewController(withIdentifier: "cycleViewController"))!, at: 1)
        }
        
        viewControllers = controllers
        for tabBar in tabBar.items! {
            tabBar.title = "Item"
        }
    }

}
