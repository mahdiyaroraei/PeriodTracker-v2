//
//  ViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/20/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RQShineLabel

class ViewController: UIViewController , CAAnimationDelegate {
    @IBOutlet weak var appNameLabel: RQShineLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appNameLabel.text = "PERIOD TRACKER"
        appNameLabel.shine()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "BuyViewController") as! UIViewController
            self.present(controller, animated: true, completion: nil)
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

