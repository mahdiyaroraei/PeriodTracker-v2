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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if !UserDefaults.standard.bool(forKey: "imported_mood") {
            importMoodTable()
        }
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
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
    }


}

