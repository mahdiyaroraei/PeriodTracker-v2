//
//  Mood.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/22/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import RealmSwift

class Mood: Object {
    dynamic var name = ""
    dynamic var color = ""
    dynamic var multiselect = 0
    dynamic var fa_name = ""
    dynamic var value_type = ""
    dynamic var enable = 0
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
