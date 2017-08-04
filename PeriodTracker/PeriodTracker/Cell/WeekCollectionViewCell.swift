//
//  WeekCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/30/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class WeekCollectionViewCell: UICollectionViewCell , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    var weekDate: Date!
    var calendar = Calendar(identifier: .persian)
    
    // Selected cell layer
    var strokeLayer: CAShapeLayer?
    var todayStrokeLayer: CAShapeLayer?
    
    var isPregnant = false
    
    weak var delegate: SelectCellDelegate?
    
    func refresh() {
        
        strokeLayer?.removeFromSuperlayer()
        todayStrokeLayer?.removeFromSuperlayer()
        
        calendar.firstWeekday = 7
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
        self.daysCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.daysCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DayCollectionViewCell
        
        cell.deSelect()
        
        let startOfWeekDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear , .weekOfYear], from: weekDate))
        
        cell.dayDate = calendar.date(byAdding: .day, value: indexPath.row, to: startOfWeekDate!)
        cell.refresh()
        
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
    
    // Handle click on item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = daysCollectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
        
        // Check don't select future
        if (cell.dayDate == nil || cell.dayDate > Date() || cell.dayDate == CalendarViewController.selectedDate) && !isPregnant{ // If in pregnant mode don't problem to select future
            if cell.dayDate != nil && cell.dayDate > Date() {
                self.delegate?.cannotSelectFuture()
            }
            return
        }
        
        // Clear selected cell and redraw for new selection
        if strokeLayer != nil {
            strokeLayer?.removeFromSuperlayer()
            CalendarViewController.selectedDate = nil
        }
        
        CalendarViewController.selectedDate = cell.dayDate
        // Change title after selecting cell
        delegate?.changeTitle(title: Utility.timeAgoSince(cell.dayDate))
        
        self.delegate?.updateTableView()
    }
    
    func selectCell(cell: DayCollectionViewCell) {
        
        let circlePath = UIBezierPath(arcCenter: cell.center , radius: cell.frame.size.width / 2 + 3, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Minus 2 for minimum distance define in storyboard
        let collectionCellSize = (self.frame.size.width - 20) / 7 - 4
        
        return CGSize(width: collectionCellSize, height: collectionCellSize)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
}
