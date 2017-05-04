//
//  NSLayoutConstraint+OnePercent.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 5. 5..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import UIKit
import DeviceGuru

@IBDesignable
class DeviceConstraints: NSLayoutConstraint {
    
    @IBInspectable var iPhone5Constant: CGFloat = 0 {
        didSet {
            super.constant = defaultConstant
        }
    }
    @IBInspectable var iPhone6Constant: CGFloat = 0 {
        didSet {
            super.constant = defaultConstant
        }
    }
    @IBInspectable var iPhone6PlusConstant: CGFloat = 0 {
        didSet {
            super.constant = defaultConstant
        }
    }
    @IBInspectable var defaultConstant: CGFloat = 0 {
        didSet {
            super.constant = defaultConstant
        }
    }
    
    override var constant: CGFloat {
        get {
            switch DeviceGuru.hardware() {
            case Hardware.iphone_5, Hardware.iphone_5C, Hardware.iphone_5S, Hardware.iphone_SE:
                return iPhone5Constant
            case Hardware.iphone_6, Hardware.iphone_6S ,Hardware.iphone_7:
                return iPhone6Constant
            case Hardware.iphone_6_PLUS, Hardware.iphone_6S_PLUS, Hardware.iphone_7_PLUS:
                return iPhone6PlusConstant
            default:
                return defaultConstant
            }
        }
        set {
            defaultConstant = newValue
        }
    }
    
}
