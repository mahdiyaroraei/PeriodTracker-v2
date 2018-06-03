//
//  Comment.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/26/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import Foundation
class Comment {
    var id: Int
    var userId: Int
    var articleId: Int
    var parentId: Int?
    var addedTime: Date
    var content: String
    var email: String
    
    var sendingComment = false
    
    init(id: Int, userId: Int, articleId: Int, parentId: Int?, addedTime: Date , content:String , email: String) {
        self.id = id
        self.userId = userId
        self.articleId = articleId
        self.parentId = parentId
        self.addedTime = addedTime
        self.content = content
        self.email = email
    }
}
