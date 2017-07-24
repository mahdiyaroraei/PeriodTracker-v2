//
//  SetupPageViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/20/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class SetupPageViewController: UIPageViewController, UIPageViewControllerDelegate , UIPageViewControllerDataSource {
    
    let pages = ["lastPeriodViewController" , "cycleLenghtViewController" , "periodLengthViewController"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Utility.uicolorFromHex(rgbValue: 0xF6F6F6)

        self.delegate = self
        self.dataSource = self
        
        // Set init visible item in pagecontroller
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: pages[0]) else {
            return
        }
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let identifier = viewController.restorationIdentifier else {
            return nil
        }
        
        guard let index = pages.index(of: identifier) else {
            return nil
        }
        
        if index > 0 {
            return self.storyboard?.instantiateViewController(withIdentifier: pages[index - 1])
        }else{
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let identifier = viewController.restorationIdentifier else {
            return nil
        }
        
        guard let index = pages.index(of: identifier) else {
            return nil
        }
        
        if index < pages.count - 1 {
            return self.storyboard?.instantiateViewController(withIdentifier: pages[index + 1])
        }else{
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
