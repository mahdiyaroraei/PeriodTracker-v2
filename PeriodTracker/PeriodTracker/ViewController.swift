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
            
            self.animationEnd = true
            self.takeAction()
            
        }
    }
    
    let loadingActivityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicatorView.startAnimating()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let realm = try! Realm()
        let user = realm.objects(User.self).last
        if (user != nil){
            if Reachability.isConnectedToNetwork() {
                if (user?.license_id)! > 0{
                    //Check license status with alamofire
                    self.checkUserLicense()
                }else{
                    self.isLicenseValid = false
                    self.apiResult = true
                    takeAction()
                }
            }else{
                if (user?.license_id)! > 0{
                    //Open app
                    self.isLicenseValid = true
                    self.apiResult = true
                    takeAction()
                }else{
                    self.isLicenseValid = false
                    self.apiResult = true
                    takeAction()
                }
            }
        }else{
            self.isLicenseValid = false
            self.apiResult = true
            takeAction()
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
                        UserDefaults.standard.set(true, forKey: "another-device-use-this-code")
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
                if !UserDefaults.standard.bool(forKey: "setup-complete") {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "setupPageViewController")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
                    self.present(vc!, animated: true, completion: nil)
                }
            } else {
                if let user = realm.objects(User.self).last {
                    try! realm.write {
                        realm.delete(user)
                    }
                }
                openPurchaseController()
            }
        } else if animationEnd {
            self.view.addSubview(loadingActivityIndicatorView)
            self.view.addConstraint(NSLayoutConstraint(item: loadingActivityIndicatorView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: loadingActivityIndicatorView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -25))
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

