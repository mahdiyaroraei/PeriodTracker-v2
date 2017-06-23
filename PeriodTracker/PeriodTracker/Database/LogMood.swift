//
//  LogMood.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/22/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import RealmSwift

class LogMood: Object {
    dynamic var log: Log?
    dynamic var mood: Mood?
    dynamic var level = -1
}
