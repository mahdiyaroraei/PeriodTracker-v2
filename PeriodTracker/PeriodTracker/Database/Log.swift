//
//  Log.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/22/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import RealmSwift

class Log: Object {
    dynamic var timestamp: Double = 0.0
    dynamic var period = -1
    dynamic var prediction = -1
    let moods = List<LogMood>()
}