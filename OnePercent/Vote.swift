//
//  Vote.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 12. 27..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import Foundation
import RealmSwift

class Vote: Object {
    
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
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
