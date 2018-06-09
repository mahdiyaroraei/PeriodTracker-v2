//
//  Topic.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 12/25/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Foundation
struct Topic: Decodable {
    var id: Int
    var subject: String
    var content: String
    var category: String?
    var user: Users
    var created_at: Date
    var updated_at: Date
    var disallow_send_message: Int?
}
