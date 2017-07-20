//
//  MoodsCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/6/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class MoodsCollectionViewCell: UICollectionViewCell , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var moodCollectionView: UICollectionView!
    
    var moods: [Mood] = []
    var delegate: SelectMoodDelegate!
    
    func refresh() {
        moodCollectionView.delegate = self
        moodCollectionView.dataSource = self
        moodCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.moodCollectionView.dequeueReusableCell(withReuseIdentifier: "mood_cell", for: indexPath) as! MoodCollectionViewCell
        
        cell.color = Utility.uicolorFromHex(rgbValue: UInt32(moods[indexPath.row].color, radix: 16)!)
        cell.name = moods[indexPath.row].name
        cell.mood = moods[indexPath.row]
        cell.refresh()
        cell.deselect()
        
        if DayLogViewController.selectedName != nil && DayLogViewController.selectedName == cell.name {
            cell.select()
            delegate.updateCollectinView(cell: cell , moodCell: self)
        }
    
        return cell
    }
    
    // Handle click on item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = moodCollectionView.cellForItem(at: indexPath) as! MoodCollectionViewCell
        
        if cell.name == "manage_mood" {
            delegate.presentViewController("moodSelectorViewController")
        }else{
            DayLogViewController.selectedName = cell.name
            delegate.updateCollectinView(cell: cell , moodCell: self)
        }
        
    }
    
    func selectCell(cell: MoodCollectionViewCell) {
//        CalendarViewController.selectedDate = cell.dayDate
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: cell.frame.origin.x + cell.frame.size.width / 2, y: cell.frame.origin.y + cell.frame.size.height / 2), radius: cell.frame.size.width / 2 + 3, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Minus 2 for minimum distance define in storyboard
        let collectionCellSize = (moodCollectionView.frame.size.width - 20) / 3 - 10
        
        return CGSize(width: collectionCellSize, height: collectionCellSize)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moods.count
    }
}

protocol SelectMoodDelegate {
    func updateCollectinView(cell: MoodCollectionViewCell , moodCell: MoodsCollectionViewCell)
    func presentViewController(_ identifier: String)
}
