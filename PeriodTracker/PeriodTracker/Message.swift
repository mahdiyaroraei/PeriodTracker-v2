//
//  Message.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 12/25/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Foundation
struct Message: Decodable {
    var id: Int
    var message: String
    var topic: Topic
    var user: Users
    var created_at: Date
    var updated_at: Date
}
