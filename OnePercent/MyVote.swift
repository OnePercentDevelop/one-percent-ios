//
//  MyVote.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 12. 27..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import Foundation
import RealmSwift

class MyVote: Object {
    dynamic var myVoteDate = ""
    dynamic var selectedNumber = ""
    
    override static func primaryKey() -> String? {
        return "myVoteDate"
    }

// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
