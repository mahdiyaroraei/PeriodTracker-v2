//
//  MoodSelectorTableViewCell.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/17/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class MoodSelectorTableViewCell: UITableViewCell {
    
    let realm = try! Realm()
    var mood: Mood! = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var moodSwitch: UISwitch!
    @IBOutlet weak var moodNameLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func moodStateChanged(_ sender: Any) {
        
        try! realm.write {
            mood.enable = moodSwitch.isOn ? 1 : 0
        }
        
    }
    
}
