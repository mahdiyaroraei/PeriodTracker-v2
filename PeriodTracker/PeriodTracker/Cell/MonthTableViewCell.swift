//
//  MonthTableViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/24/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class MonthTableViewCell: UITableViewCell , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    var monthDate: Date!
    var calendar = Calendar(identifier: .persian)
    
    // sync start weekday
    var difference = 0
    
    var daysInMonth = 0
    var weekDay = 0
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    func refresh() {
        // get start of month
        monthDate = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate))!
        
        // compute days in month
        daysInMonth = (calendar.range(of: .day, in: .month, for: monthDate)?.count)!
        
        // compute start of month day of week
        weekDay = calendar.dateComponents([.weekday], from: monthDate!).weekday!
        
        let dateComponents = calendar.dateComponents([.year , .month], from: monthDate)
        monthLabel.text = "\(MONTH[dateComponents.month! - 1]) - \(String(describing: dateComponents.year!))"
        
        difference = 0
        daysCollectionView.delegate = self
        daysCollectionView.dataSource = self
        daysCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 49
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = daysCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DayCollectionViewCell

        let dayDate = calendar.date(byAdding: .day, value: indexPath.row - difference, to: monthDate)
        
        // check start day of week
        if indexPath.row < 7 {
            if weekDay <= indexPath.row {
                cell.backgroundColor = UIColor.gray
                cell.dayDate = dayDate
                cell.refresh()
            }else{
                difference += 1
                cell.empty()
            }
        }else{
            if indexPath.row - difference >= daysInMonth {
                cell.empty()
            }else{
                cell.backgroundColor = UIColor.gray
                cell.dayDate = dayDate
                cell.refresh()
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Minus 2 for minimum distance define in storyboard
        let collectionCellSize = daysCollectionView.frame.size.width / 7 - 2
        
        return CGSize(width: collectionCellSize, height: collectionCellSize)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
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

}
