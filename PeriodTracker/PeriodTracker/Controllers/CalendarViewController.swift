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

    @IBAction func goToToday(_ sender: Any) {
        monthsTableView.scrollToRow(at: IndexPath(row: 25, section: 0), at: .middle, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayLabel.text = "\(String(describing: Calendar(identifier: .persian).dateComponents([.day], from: nowDate).day!))"
        
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
