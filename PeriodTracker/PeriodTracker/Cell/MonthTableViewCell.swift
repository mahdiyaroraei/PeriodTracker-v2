//
//  MonthTableViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/24/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

// for update tableview after selecting another cell for deselect enabled cell from another collectionview
protocol SelectCellDelegate: class {
    func updateTableView()
    func cannotSelectFuture()
    func changeTitle(title: String)
    func presentVC(id: String)
}

class MonthTableViewCell: UITableViewCell , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    // Selected cell layer
    var strokeLayer: CAShapeLayer?
    var todayStrokeLayer: CAShapeLayer?
    
    var monthDate: Date!
    var calendar = Calendar(identifier: .persian)
    
    // sync start weekday
    var difference = 0
    
    var daysInMonth = 0
    var weekDay = 0
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    weak var delegate: SelectCellDelegate?
    
    func refresh() {
        // get start of month
        monthDate = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate))!
        
        // Clear today select and stroke select and if need redraw them in collectionview don't worry :)
        strokeLayer?.removeFromSuperlayer()
        todayStrokeLayer?.removeFromSuperlayer()
        
        // compute days in month
        daysInMonth = (calendar.range(of: .day, in: .month, for: monthDate)?.count)!
        
        // compute start of month day of week
        weekDay = calendar.dateComponents([.weekday], from: monthDate!).weekday!
        if weekDay == 7 {
            weekDay = 0
        }
        
        // Compute year and month for table view cell header label
        let dateComponents = calendar.dateComponents([.year , .month], from: monthDate)
        
        // Two style in one label
        let dateString = NSMutableAttributedString(
            string: "\(MONTH[dateComponents.month! - 1]) - \(String(describing: dateComponents.year!))",
            attributes: [:])
        
        dateString.addAttribute(NSFontAttributeName, value: UIFont(name: "IRANSansFaNum-Bold", size: 12)!, range: NSRange(location: 0, length: MONTH[dateComponents.month! - 1].characters.count))
        
        monthLabel.attributedText = dateString
        
        // Add top and bottom border for monthLabel
        let topLineLayer = CALayer()
        topLineLayer.backgroundColor = Colors.normalCellColor.cgColor
        topLineLayer.frame = CGRect(x:-50,y: 0, width:monthLabel.frame.size.width + 100, height:1)
        monthLabel.layer.addSublayer(topLineLayer)
        
        let bottomLineLayer = CALayer()
        bottomLineLayer.backgroundColor = Colors.normalCellColor.cgColor
        bottomLineLayer.frame = CGRect(x:-50, y:monthLabel.frame.size.height - 1, width:monthLabel.frame.size.width + 100, height:1)
        monthLabel.layer.addSublayer(bottomLineLayer)
        
        difference = 0
        daysCollectionView.isScrollEnabled = false
        daysCollectionView.delegate = self
        daysCollectionView.dataSource = self
        daysCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 49
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = daysCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DayCollectionViewCell
        
        cell.deSelect()

        let dayDate = calendar.date(byAdding: .day, value: indexPath.row - difference, to: monthDate)
        
        // check start day of week
        if indexPath.row < 7 {
            if weekDay <= indexPath.row {
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
                cell.dayDate = dayDate
                cell.refresh()
            }
        }
        
        // Draw circle if cell date == today
        if cell.dayDate != nil {
            if calendar.isDateInToday(cell.dayDate!) {
                
                let circlePath = UIBezierPath(arcCenter: CGPoint(x: cell.frame.origin.x + cell.frame.size.width / 2, y: cell.frame.origin.y + cell.frame.size.height / 2), radius: cell.frame.size.width / 2 + 3, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
                
                todayStrokeLayer = CAShapeLayer()
                todayStrokeLayer?.path = circlePath.cgPath
                
                //change the fill color
                todayStrokeLayer?.fillColor = UIColor.clear.cgColor
                //you can change the stroke color
                todayStrokeLayer?.strokeColor = Colors.accentColor.cgColor
                //you can change the line width
                todayStrokeLayer?.lineWidth = 5.0
                
                // add to collection layer for draw on top of cell
                self.daysCollectionView.layer.addSublayer(todayStrokeLayer!)
            }
        }
        
        if cell.dayDate != nil && cell.dayDate == CalendarViewController.selectedDate {
            selectCell(cell: cell)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Minus 2 for minimum distance define in storyboard
        let collectionCellSize = (daysCollectionView.frame.size.width - 20) / 7 - 2
        
        return CGSize(width: collectionCellSize, height: collectionCellSize)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = daysCollectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
        
        // Check don't select future
        if cell.dayDate == nil || cell.dayDate > Date() || cell.dayDate == CalendarViewController.selectedDate{
            if cell.dayDate != nil && cell.dayDate > Date() {
                self.delegate?.cannotSelectFuture()
            }
            // If tap on selected day goto dayViewController
            if cell.dayDate == CalendarViewController.selectedDate {
                delegate?.presentVC(id: "dayLogViewController")
            }
            return
        }
        
        // Clear selected cell and redraw for new selection
        if strokeLayer != nil {
            strokeLayer?.removeFromSuperlayer()
            CalendarViewController.selectedDate = nil
        }
        
        selectCell(cell: cell)
        // Change title after selecting cell
        delegate?.changeTitle(title: Utility.timeAgoSince(cell.dayDate))
        
        self.delegate?.updateTableView()
    }
    
    func selectCell(cell: DayCollectionViewCell) {
        CalendarViewController.selectedDate = cell.dayDate
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: cell.frame.origin.x + cell.frame.size.width / 2, y: cell.frame.origin.y + cell.frame.size.height / 2), radius: cell.frame.size.width / 2 + 3, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        strokeLayer = CAShapeLayer()
        strokeLayer?.path = circlePath.cgPath
        
        //change the fill color
        strokeLayer?.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        strokeLayer?.strokeColor = Colors.accentColor.cgColor
        //you can change the line width
        strokeLayer?.lineWidth = 7.0
        
        // add to collection layer for draw on top of cell
        self.daysCollectionView.layer.addSublayer(strokeLayer!)
        
        cell.select()
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
