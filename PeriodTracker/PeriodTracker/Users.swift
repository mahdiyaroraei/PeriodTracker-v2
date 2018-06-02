//
//  User.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 12/25/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Foundation
struct Users: Decodable {
    var id: Int
    var email: String
    var nikname: String?
    var player_id: String?
    var created_at: Date?
    var updated_at: Date?
    var verified: Int?
}
