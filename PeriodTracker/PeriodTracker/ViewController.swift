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

class ViewController: UIViewController , CAAnimationDelegate {
    @IBOutlet weak var appNameLabel: RQShineLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appNameLabel.text = "PERIOD TRACKER"
        appNameLabel.shine()
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            let realm = try! Realm()
            let user = realm.objects(User.self).first
            if (user != nil){
                if Reachability.isConnectedToNetwork() {
                    if (user?.license_id)! > 0{
                        //Check license status with alamofire
                        self.checkUserLicense()
                    }else{
                        //Purchase page
                        print("Purchase page")
                    }
                }else{
                    if (user?.license_id)! > 0{
                        //Open app
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! CalendarViewController
                        self.present(vc, animated: true, completion: nil)
                    }else{
                        //Purchase page
                        print("Purchase page")
                    }
                }
            }else{
                //Purchase page
                print("Purchase page")
            }
            
            //Open app
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
            self.present(vc!, animated: true, completion: nil)
            
        }
    }
    
    func checkUserLicense() {
        let params: [String: Any] = ["license_id": 20, "user_id": 1]
        Alamofire.request(PeriodTrackerRouter.checkLicenseStatus(params)).responseJSON { response in
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling POST on /todos/1")
                print(response.result.error!)
                return
            }
            // make sure we got some JSON since that's what we expect
            guard let json = response.result.value as? [String: Any] else {
                print("didn't get todo object as JSON from API")
                print("Error: \(response.result.error)")
                return
            }
            // get and print the title
            guard let status = json["status"] as? Int else {
                print("Could not get todo title from JSON")
                return
            }
            
            switch status{
            case -1:
                //Purchase page
                break
            case 0:
                //Another device use this license
                //Purchase page
                break
            case 1:
                //Open app
                break
            default:
                break
            }

        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // Splash screen goto app
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

