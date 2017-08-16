//
//  Guide.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/12/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Foundation
class Guide {
    var key: String
    var content: [Item]!
    var fa_key: String
    
    init(key: String, content: [Item]!) {
        self.key = key
        self.content = content
        self.fa_key = Utility.translate(key: key)! // TODO get from translate dic
    }
}
