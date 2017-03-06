//
//  Prize.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 12. 27..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class PrizeResponse: Mappable {
    var winnerResult: [Prize]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        winnerResult <- map["winnerResult"]
    }
}

class Prize: Object, Mappable {
    dynamic var prizeDate = ""
    dynamic var winner = ""
    dynamic var giftName = ""
    dynamic var giftUrl = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
  
    func mapping(map: Map) {
        prizeDate <- map["vote_date"]
        winner <- map["winner"]
        giftName <- map["gift_name"]
        giftUrl <- map["gift_png"]
    }
    
    override static func primaryKey() -> String? {
        return "prizeDate"
    }
}
