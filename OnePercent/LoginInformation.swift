//
//  LoginInformation.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 11. 6..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class LoginInformationResponse: Mappable {
    var loginResult: [LoginInformation]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        loginResult <- map["login_result"]
    }
}

class LoginInformation: Mappable {
    var state: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        state <- map["state"]
    }
}
