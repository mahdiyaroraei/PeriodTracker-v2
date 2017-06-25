//
//  DayCollectionViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/24/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    
    var dayDate: Date!
    var calendar = Calendar(identifier: .persian)
    
    func refresh() {
        let dateComponents = calendar.dateComponents([.day], from: dayDate)
        dayLabel.text = "\(String(describing: dateComponents.day!))"
    }
    
    func empty() {
        backgroundColor = UIColor.white
        dayLabel.text = ""
    }
}
