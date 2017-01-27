//
//  Vote.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 12. 27..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class VoteResponse: Mappable {
    var voteTotalResult: [Vote]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        voteTotalResult <- map["voteTotalResult"]
    }
}

class Vote: Object, Mappable {
    
    dynamic var voteDate = ""
    dynamic var question = ""
    dynamic var ex1 = ""
    dynamic var ex2 = ""
    dynamic var ex3 = ""
    dynamic var ex4 = ""
    dynamic var count1 = 0
    dynamic var count2 = 0
    dynamic var count3 = 0
    dynamic var count4 = 0
    dynamic var entryAmount = 0
    dynamic var winnerAmount = 0
    
    override static func primaryKey() -> String? {
        return "voteDate"
    }
    
    required convenience init(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        voteDate <- map["vote_date"]
        question <- map["vote_question"]
        ex1 <- map["ex1_value"]
        ex2 <- map["ex2_value"]
        ex3 <- map["ex3_value"]
        ex4 <- map["ex4_value"]
        count1 <- map["ex1_count"]
        count2 <- map["ex2_count"]
        count3 <- map["ex3_count"]
        count4 <- map["ex4_count"]
        entryAmount <- map["total_count"]
        winnerAmount <- map["prize_count"]

    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}

