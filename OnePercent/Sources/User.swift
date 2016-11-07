//
//  User.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 10. 28..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

//class User {
//    static let sharedInstance: User = {
//        let instance = User(id: "", password: "", token: "")
//        return instance
//    }()
//    
//    var emptyId: String
//    var emptyPassword: String
//    var emptyToken: String
//    
//    init(id: String, password: String, token: String) {
//        emptyId = id
//        emptyPassword = password
//        emptyToken = token
//    }
//}

extension DefaultsKeys {
    static let isSignIn = DefaultsKey<Bool>("isSignIn")
}
