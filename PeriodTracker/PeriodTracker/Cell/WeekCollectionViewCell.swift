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
    
    var todayStrokeLayer: CAShapeLayer?
    
    func refresh() {
        todayStrokeLayer?.removeFromSuperlayer()
        calendar.firstWeekday = 7
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
        self.daysCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.daysCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DayCollectionViewCell
        
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

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Minus 2 for minimum distance define in storyboard
        let collectionCellSize = (daysCollectionView.frame.size.width - 20) / 7 - 4
        
        return CGSize(width: collectionCellSize, height: collectionCellSize)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
}
