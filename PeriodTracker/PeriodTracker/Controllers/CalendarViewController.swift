//
//  CalendarViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/24/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var monthsTableView: UITableView!
    
    let cellReuseIdentifier = "cell"
    let calendar = Calendar(identifier: .persian)
    let MONTH = [
        "فروردین" ,
        "اردیبهشت" ,
        "خرداد" ,
        "تیر" ,
        "مرداد" ,
        "شهریور" ,
        "مهر" ,
        "آبان" ,
        "آذر" ,
        "دی" ,
        "بهمن" ,
        "اسفند"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the table view cell class and its reuse id
        self.monthsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        monthsTableView.delegate = self
        monthsTableView.dataSource = self
        //Select middle cell for start showing
        monthsTableView.selectRow(at: IndexPath(row: 25, section: 0), animated: false, scrollPosition: .middle)
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
        let cell:MonthTableViewCell = self.monthsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MonthTableViewCell!
        
        cell.monthLabel.text = MONTH[calendar.dateComponents([.month], from: Date()).month!]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tap!")
    }

}
