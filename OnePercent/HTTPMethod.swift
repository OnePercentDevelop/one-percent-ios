//
//  HTTPMethod.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 10. 31..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
