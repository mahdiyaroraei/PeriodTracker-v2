//
//  Music.swift
//  iFit
//
//  Created by Mostafa Oraei on 11/23/1396 AP.
//  Copyright © 1396 Mostafa Oraei. All rights reserved.
//

import Foundation

struct Music: Decodable, Encodable {
    var id: Int
    var cover_url: String?
    var name: String
    var category: String
    var artist: String?
    var size: Double?
    var link: String
    var isDownloaded: Int?
}
