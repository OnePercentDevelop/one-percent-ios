//
//  OnepercentDefaultKeys.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 3. 20..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let isSignIn = DefaultsKey<Bool>("false")
    static let id = DefaultsKey<String>("id")
    static let pushAlarm = DefaultsKey<Bool>("true")
    static let silence = DefaultsKey<Bool>("true")
}
