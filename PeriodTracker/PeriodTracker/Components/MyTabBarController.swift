//
//  MyTabBarController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/8/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift
import OneSignal

class MyTabBarController: UITabBarController ,UITabBarControllerDelegate {
    
    public static var instance: MyTabBarController!
    
    var controllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        var imageNames: [String] = ["tab-calendar", "tab-setting", "tab-article" , "tab-topics"]
        var tabTitles: [String] = ["تقویم", "تنظیمات", "مقالات" ,"تالار"]
        
        MyTabBarController.instance = self
        
        controllers.removeAll()
        
        controllers.append((self.storyboard?.instantiateViewController(withIdentifier: "calendarViewController"))!)
        controllers.append((self.storyboard?.instantiateViewController(withIdentifier: "settingViewController"))!)
        controllers.append((self.storyboard?.instantiateViewController(withIdentifier: "articlesViewController"))!)
        
        controllers.append(UINavigationController(rootViewController: TopicsViewController()))
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !UserDefaults.standard.bool(forKey: "show-notification-alert") {
            showModal(modalObject: Modal(title: "ارسال ناتیفیکیشن", desc: "برنامه برای اطلاع رسانی دوره بعدی شما و اطلاع رسانی انتشار مقاله جدید نیاز به اجازه شما به برنامه برای ارسال ناتیفیکیشن دارد.", image: UIImage(named: "modal-notification"), leftButtonTitle: "باشه", rightButtonTitle: "اجازه نمیدم", onLeftTapped: { (modal) in
                
                
                // Recommend moving the below line to prompt for push after informing the user about
                //   how your app will use them.
                
                modal.dismissModal()
                
                OneSignal.promptForPushNotifications(userResponse: { accepted in
                    print("User accepted notifications: \(accepted)")
                })
            }, onRightTapped: { (modal) in
                modal.dismissModal()
            }))
            UserDefaults.standard.set(true, forKey: "show-notification-alert")
        }
    }
    
    var canScroll = false
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.childViewControllers.count > 0 , let articleViewController = viewController.childViewControllers[0] as? ArticleViewController { // viewController is NavigationController actually
            if canScroll {
                articleViewController.scrollToTop()
            } else {
                canScroll = true
            }
        } else {
            canScroll = false
        }
    }

}
