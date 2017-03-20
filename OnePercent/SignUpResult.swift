//
//  SignUpResult.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 11. 6..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import Foundation
import ObjectMapper

class SignUpResultResponse: Mappable {
    var signUpResult: [SignUpResult]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        signUpResult <- map["sign_result"]
    }
}

class SignUpResult: Mappable {
    var state: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        state <- map["state"]
    }
}
