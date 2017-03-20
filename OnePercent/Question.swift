//
//  Question.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 2. 16..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation
import ObjectMapper

class QuestionResponse: Mappable {
    var todayQuestion: [Question]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        todayQuestion <- map["todayQuestion"]
    }
}

class Question: Mappable {
    var question: String = ""
    var ex1: String = ""
    var ex2: String = ""
    var ex3: String = ""
    var ex4: String = ""
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        question <- map["vote_question"]
        ex1 <- map["ex1_value"]
        ex2 <- map["ex2_value"]
        ex3 <- map["ex3_value"]
        ex4 <- map["ex4_value"]
    }
}
