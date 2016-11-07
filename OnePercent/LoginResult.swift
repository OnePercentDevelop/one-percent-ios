//
//  LoginResult.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 11. 6..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginResultResponse: Mappable {
    var loginResult: [LoginResult]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        loginResult <- map["login_result"]
    }
}

class LoginResult: Mappable {
    var state: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        state <- map["state"]
    }
}
