//
//  AttributeText.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/7/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Foundation

class AttributeText {
    var key: String!
    var value: Any?
    var range: NSRange?
    
    init(key: String!, value: Any?, range: NSRange?) {
        self.key = key
        self.value = value
        self.range = range
    }
    
}
