//
//  Setting.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/6/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class SettingModel: NSObject {
    var name: String!
    var type: SettingType?
    var key: String!
    
    init(_ name: String , type: SettingType , key: String) {
        self.name = name
        self.type = type
        self.key = key
    }
}
enum SettingType {
    case normal
    case action
}
