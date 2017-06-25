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
    
    // start of day and month
    let nowDate = Calendar.current.startOfDay(for: Date())


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        monthsTableView.delegate = self
        monthsTableView.dataSource = self
        
        // set delay for change table view cell height
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            // Select middle cell for start showing today
            self.monthsTableView.selectRow(at: IndexPath(row: 25, section: 0), animated: false, scrollPosition: .middle)
        }
        
        // Hide scrollbar
        monthsTableView.showsHorizontalScrollIndicator = false
        monthsTableView.showsVerticalScrollIndicator = false
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
        
        cell.monthDate = Calendar.current.date(byAdding: .month, value: indexPath.row - 25 , to: nowDate)
        cell.refresh()
        
        return cell
    }
    
    // return tableview cell height for no additional padding
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewCellHeight = monthsTableView.frame.size.width + 50
        
        return tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tap!")
    }

}
