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
    dynamic var multiselect = true
}
