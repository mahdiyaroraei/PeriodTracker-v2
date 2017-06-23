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
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
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

