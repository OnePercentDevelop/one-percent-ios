//
//  UIColor.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 12. 23..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
