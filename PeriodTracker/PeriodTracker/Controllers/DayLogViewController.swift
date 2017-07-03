//
//  DayLogViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/30/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class DayLogViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,
SelectCellDelegate{

    @IBOutlet weak var weekCollectionView: UICollectionView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    let calendar = Calendar(identifier: .persian)
    
    
    // start of day and month
    let nowDate = Calendar.current.startOfDay(for: Date())
    
    // After select item viewDidLayoutSubviews called again for avoid scroll use this
    var scrolledFirst = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayLabel.text = "\(String(describing: Calendar(identifier: .persian).dateComponents([.day], from: nowDate).day!))"

        self.weekCollectionView.dataSource = self
        self.weekCollectionView.delegate = self
        
        self.weekCollectionView.showsHorizontalScrollIndicator = false
        
        // For scrolling like a page and not stay at middle of item
        self.weekCollectionView.isPagingEnabled = true
        
        
        // Add top and bottom border for stackView
        let topLineLayer = CALayer()
        topLineLayer.backgroundColor = Colors.normalCellColor.cgColor
        topLineLayer.frame = CGRect(x:-50,y: 0, width:stackView.frame.size.width + 100, height:1)
        stackView.layer.addSublayer(topLineLayer)
        
        let bottomLineLayer = CALayer()
        bottomLineLayer.backgroundColor = Colors.normalCellColor.cgColor
        bottomLineLayer.frame = CGRect(x:-50, y:stackView.frame.size.height - 1, width:stackView.frame.size.width + 100, height:1)
        stackView.layer.addSublayer(bottomLineLayer)
    }
    
    // Scroll to current after layout subviews completed
    override func viewDidLayoutSubviews() {
        if !scrolledFirst {
            // Scroll to current week
            self.weekCollectionView.scrollToItem(at: IndexPath(row: 25, section: 0), at: .left, animated: false)
        }
    }
    
    @IBAction func gotoCurrentWeek(_ sender: Any) {
        self.weekCollectionView.scrollToItem(at: IndexPath(row: 25, section: 0), at: .left, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 51 week show and middle of items is currently week
        return 51
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.weekCollectionView.dequeueReusableCell(withReuseIdentifier: "week_cell", for: indexPath) as! WeekCollectionViewCell
        
        cell.delegate = self
        cell.weekDate = calendar.date(byAdding: .weekOfYear, value: indexPath.row - 25 , to: nowDate)
        cell.refresh()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 60)
    }
    
    func updateTableView() {
        self.scrolledFirst = true
        self.weekCollectionView.reloadData()
    }
    
    func cannotSelectFuture() {
        showToast(message: "نمی‌توانید روز های آینده را انتخاب کنید!")
    }
    
    func changeTitle(title: String) {
        titleLabel.text = title
    }

}

extension UIViewController{
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 110, y: self.view.frame.size.height-100, width: 220, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "IRANSans(FaNum)", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1, delay: 0.8, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
