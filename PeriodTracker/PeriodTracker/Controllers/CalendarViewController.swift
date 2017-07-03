//
//  CalendarViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/24/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , SelectCellDelegate {
    @IBOutlet weak var monthsTableView: UITableView!
    
    @IBOutlet weak var stackView: UIStackView!
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    
    // start of day and month
    let nowDate = Calendar.current.startOfDay(for: Date())
    
    static var selectedDate: Date?
    
    // After select item viewDidLayoutSubviews called again for avoid scroll use this
    var scrolledFirst = false

    @IBAction func goToToday(_ sender: Any) {
        monthsTableView.scrollToRow(at: IndexPath(row: 25, section: 0), at: .middle, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayLabel.text = "\(String(describing: Calendar(identifier: .persian).dateComponents([.day], from: nowDate).day!))"
        
        monthsTableView.delegate = self
        monthsTableView.dataSource = self
        
        // Hide scrollbar
        monthsTableView.showsHorizontalScrollIndicator = false
        monthsTableView.showsVerticalScrollIndicator = false
        
        // Hide seperator line between cells
        monthsTableView.separatorStyle = .none
        
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
            // Select middle cell for start showing today
            self.monthsTableView.selectRow(at: IndexPath(row: 25, section: 0), animated: false, scrollPosition: .middle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 51
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = self.monthsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MonthTableViewCell
        
        // for hide highlight
        cell.selectionStyle = .none
        
        // for update tableview after selecting cell from collectionview
        cell.delegate = self
        
        cell.monthDate = Calendar.current.date(byAdding: .month, value: indexPath.row - 25 , to: nowDate)
        cell.refresh()
        
        return cell
    }
    
    func updateTableView() {
        self.scrolledFirst = true
        self.monthsTableView.reloadData()
    }
    
    func cannotSelectFuture() {
        showToast(message: "نمی‌توانید روز های آینده را انتخاب کنید!")
    }
    
    func changeTitle(title: String) {
        titleLabel.text = title
    }
    
    // return tableview cell height for no additional padding
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewCellHeight = monthsTableView.frame.size.width + 10
        
        return tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tap!")
    }

}
