//
//  Prize.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 12. 27..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import Foundation
import RealmSwift

class Prize: Object {
    dynamic var prizeDate = ""
    dynamic var winner = ""
    dynamic var giftName = ""
    dynamic var giftUrl = ""
    
    override static func primaryKey() -> String? {
        return "prizeDate"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
