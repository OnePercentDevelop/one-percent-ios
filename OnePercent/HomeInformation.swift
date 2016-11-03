//
//  HomeInformation.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 11. 3..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class HomeInformationResponse: Mappable {
    var mainResult: [HomeInformation]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        mainResult <- map["main_result"]
    }
}

class HomeInformation:Mappable {
    var winner: String?
    var question: String?
    var giftName: String?
    var example: [Example]?
    var giftPng: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        winner <- map["winner"]
        question <- map["question"]
        giftName <- map["gift_name"]
        example <- map["example"]
        giftPng <- map["gift_png"]

    }
}

class Example: Mappable {
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    
    var firstQuestion: String?
    var secondQuestion: String?
    var thirdQuestion: String?
    var fourthQuestion: String?

    required init?(map: Map) {
        
    }

    
    func mapping(map: Map) {
        firstQuestion <- map["1"]
        secondQuestion <- map["2"]
        thirdQuestion <- map["3"]
        fourthQuestion <- map["4"]

    }

}
