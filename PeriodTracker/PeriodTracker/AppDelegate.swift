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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if !UserDefaults.standard.bool(forKey: "imported_mood") {
            importMoodTable()
        }
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "IRANSans(FaNum)", size: 14.0)!], for: .normal)
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace '11111111-2222-3333-4444-0123456789ab' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "4cfd7b92-652b-489d-a20b-58ce48b3dcc9",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        Utility.setLocalPushForEnableNotices(withCompletionHandler: nil)
        
        return true
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

