//
//  User.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 6/22/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import RealmSwift
import Alamofire

class User: Object {

    dynamic var user_id = 0
    dynamic var email = ""
    dynamic var license_id = 0 {
        didSet {
            if let playerId = UserDefaults.standard.string(forKey: "player_id") {
                Alamofire.request("\(Config.WEB_DOMAIN)user/\(license_id)/\(playerId)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            }
        }
    }
}
