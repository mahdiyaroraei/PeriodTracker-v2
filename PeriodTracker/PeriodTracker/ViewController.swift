//
//  ViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/20/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import RQShineLabel
import SwiftyJSON

class ViewController: UIViewController , CAAnimationDelegate {
    @IBOutlet weak var appNameLabel: RQShineLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appNameLabel.text = "PERIOD TRACKER"
        appNameLabel.shine()
        
        let when = DispatchTime.now() + 3 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            let realm = try! Realm()
            let user = realm.objects(User.self).last
            if (user != nil){
                if Reachability.isConnectedToNetwork() {
                    if (user?.license_id)! > 0{
                        //Check license status with alamofire
                        self.checkUserLicense()
                    }else{
                        //Purchase page
                        self.openPurchaseController()
                    }
                }else{
                    if (user?.license_id)! > 0{
                        //Open app
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! CalendarViewController
                        self.present(vc, animated: true, completion: nil)
                    }else{
                        //Purchase page
                        self.openPurchaseController()
                    }
                }
            }else{
                //Purchase 
                self.openPurchaseController()
            }
            
            self.animationEnd = true
            self.takeAction()
            
        }
    }
    
    let realm = try! Realm()
    
    func checkUserLicense() {
        
        if let user = realm.objects(User.self).last {
            
            let parameters: Parameters = [
                "app": "period_tracker",
                "license_id": user.license_id,
                "user_id": user.user_id
            ]
            
            
            Alamofire.request("\(Config.WEB_DOMAIN)v2/login", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                
                self.apiResult = true
                
                if let data = response.data {
                    if let success = JSON(data)["success"].int , success != 1 {
                        self.isLicenseValid = false
                    }
                    self.takeAction()
                }
            })
        }

    }
    
    var animationEnd = false , apiResult = false , isLicenseValid = true
    
    func takeAction() {
        if animationEnd && apiResult {
            if isLicenseValid {
                //Open app
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
                self.present(vc!, animated: true, completion: nil)
            } else {
                if let user = realm.objects(User.self).last {
                    try! realm.write {
                        realm.delete(user)
                    }
                }
                openPurchaseController()
            }
        }
    }
    
    func openPurchaseController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "buyViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // Splash screen goto app
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

