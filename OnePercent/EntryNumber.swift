//
//  OnePercentResponse.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 11. 1..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class OnePercentResponse: Mappable {
    var voteResult: [EntryNumber]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        voteResult <- map["vote_result"]
    }
}

class EntryNumber: Mappable {
    var number: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        number <- map["number"]
    }
}
