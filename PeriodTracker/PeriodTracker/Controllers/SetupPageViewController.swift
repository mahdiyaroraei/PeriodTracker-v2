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
    
    let pageController: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 3
        pageControl.tintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        self.view.backgroundColor = Utility.uicolorFromHex(rgbValue: 0xF6F6F6)
        
        self.delegate = self
        self.dataSource = self
        
        // Set init visible item in pagecontroller
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: pages[0]) else {
            return
        }
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
    func setupViews() {
        self.view.addSubview(pageController)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageController.center = CGPoint(x: self.view.center.x, y: self.view.frame.height - 15)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let myTabBarController = self.tabBarController {
            myTabBarController.viewDidLoad()
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        var index = pages.index(of: pageContentViewController.restorationIdentifier!)!
        if index == 0 {
            index = 2
        } else if index == 2 {
            index = 0
        }
        self.pageController.currentPage = index
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
