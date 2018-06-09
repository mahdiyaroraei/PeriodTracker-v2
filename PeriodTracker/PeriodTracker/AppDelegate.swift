//
//  AppDelegate.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/20/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , OSSubscriptionObserver {

    var window: UIWindow?
    
    public static var pricingViewController: UIViewController?
    public static var buyViewController: UIViewController?
    
    public var licenseViewController: UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if !UserDefaults.standard.bool(forKey: "imported_mood") {
            importMoodTable()
        }
        
        OneSignal.add(self as OSSubscriptionObserver)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "IRANSans(FaNum)", size: 14.0)!], for: .normal)
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace '11111111-2222-3333-4444-0123456789ab' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "e3a5e04c-5585-401a-8c4a-9da217272ac3",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        Utility.setLocalPushForEnableNotices(withCompletionHandler: nil)
        
        initSetting()
                
        return true
    }
    
    
    // After you add the observer on didFinishLaunching, this method will be called when the notification subscription property changes.
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
        
        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            
            UserDefaults.standard.set(playerId, forKey: "player_id")
        }
    }
    
    func initSetting() {
        let realm = try! Realm()
        guard realm.objects(Setting.self).last != nil else {
            try! realm.write {
                let setting = Setting()
                setting.pregnantMode = 0
                realm.add(setting)
            }
            return
        }

    }
    
    private func importMoodTable() {
        do {
            let realm = try! Realm()
            if let file = Bundle.main.url(forResource: "mood", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = JSON(data: data)
                for (index,subJson):(String, JSON) in json {
                    let mood: Mood = Mood()
                    mood.name = subJson["name"].string!
                    mood.color = subJson["color"].string!
                    mood.multiselect = Int(subJson["multiselect"].string!)!
                    mood.value_type = subJson["value_type"].string!
                    mood.enable = Int(subJson["enable"].string!)!
                    
                    try! realm.write {
                        realm.add(mood)
                    }
                }
                
                UserDefaults.standard.set(true, forKey: "imported_mood")
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlComponnets = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        let items = urlComponnets?.queryItems
        
        guard items?.first?.name == "email" , let email = items?.first?.value else { return true }
        
        guard items?.last?.name == "code" , let code = items?.last?.value else { return true }
        
        let parameters = [
            "email": email,
            "code": code,
            "app": "period_tracker"
        ]
        
        
        Alamofire.request("\(Config.WEB_DOMAIN)v2/activation", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
            if let data = response.data {
                guard let licenseId = JSON(data)["license_id"].int else {
                    self.window?.rootViewController?.showToast(message: "اطلاعات صحیح نیست")
                    return
                }
                
                guard let userId = JSON(data)["user_id"].int else {
                    self.window?.rootViewController?.showToast(message: "اطلاعات صحیح نیست")
                    return
                }
                
                guard let email = JSON(data)["email"].string else {
                    self.window?.rootViewController?.showToast(message: "اطلاعات صحیح نیست")
                    return
                }
                
                Config.isPermiumUser = true
                
                let realm = try! Realm()
                if let user = realm.objects(User.self).last {
                    try! realm.write {
                        user.email = email
                        user.user_id = userId
                        user.license_id = licenseId
                    }
                } else {
                    try! realm.write {
                        let user = User()
                        user.email = email
                        user.user_id = userId
                        user.license_id = licenseId
                        
                        realm.add(user)
                    }
                }
                
                let successPaymentDialog = UIAlertController(title: "خرید موفق", message: "برنامه برای شما فعال شد، امیدواریم از برنامه لذت ببرید", preferredStyle: .alert)
                successPaymentDialog.addAction(UIAlertAction(title: "باشه", style: .default, handler: { (alert) in
                   self.licenseViewController?.dismiss(animated: true, completion: nil)
                }))
                
                self.licenseViewController?.present(successPaymentDialog, animated: true, completion: nil)
            }
        })
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // This Mine comment
    }


}

