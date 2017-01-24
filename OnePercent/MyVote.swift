//
//  MyVote.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 12. 27..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

//class MyVote: Object {
//    dynamic var myVoteDate = ""
//    dynamic var selectedNumber: Int = 0
//    
//    override static func primaryKey() -> String? {
//        return "myVoteDate"
//    }
//
//// Specify properties to ignore (Realm won't persist these)
//    
////  override static func ignoredProperties() -> [String] {
////    return []
////  }
//}

class MyVoteResponse: Mappable {
    var uservoteList: [MyVote]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        uservoteList <- map["uservote_list"]
    }
}

class MyVote: Object, Mappable {
    dynamic var myVoteDate = ""
    dynamic var selectedNumber: Int = 0

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        myVoteDate <- map["vote_date"]
        selectedNumber <- map["vote_answer"]

    }
    
    override static func primaryKey() -> String? {
        return "myVoteDate"
    }
}
