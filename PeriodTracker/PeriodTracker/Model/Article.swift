//
//  Article.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 8/6/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit

class Article: NSObject {
    public var id : Int!
    public var title : String!
    public var addedtime : String!
    public var view : Int!
    public var clap : Int!
    public var desc : String?
    public var image : String?
    public var content : [Item]! // TODO create item class
    public var creator_name : String?
    public var article_read_time : String?
    
    init(id: Int! ,
         title : String!,
         addedtime : String!,
         view : Int!,
         clap : Int!,
         desc : String?,
         image : String?,
         content : [Item]!,
         creator_name : String?,
         article_read_time : String?) {
        self.id = id
        self.title = title
        self.addedtime = addedtime
        self.view = view
        self.clap = clap
        self.desc = desc
        self.image = image
        self.content = content
        self.creator_name = creator_name
        self.article_read_time = article_read_time
    }
    
    public func increaseView(){
        self.view = self.view + Int("1")!
    }
    
    public func increaseClap(count: Int){
        self.clap = self.clap + Int("\(count)")!
    }
}
