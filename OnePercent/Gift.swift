//
//  Gift.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 2. 16..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation
import ObjectMapper

class GiftResponse: Mappable {
    var giftResult: [Gift]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        giftResult <- map["todayGift_result"]
    }
}

class Gift: Mappable {
    var giftName: String?
    var giftPng: String?
    var giftUrl: URL?
    
    init(name: String, url: String) {
        self.giftName = name
        self.giftPng = url
    }
    
    init(name: String, url: URL) {
        self.giftName = name
        self.giftUrl = url
    }
    
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        giftName <- map["gift_name"]
        giftPng <- map["gift_png"]
    }

}
