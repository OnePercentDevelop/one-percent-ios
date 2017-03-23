//
//  OnePercentButton.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 11. 28..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import UIKit

@IBDesignable
class OnePercentButton: UIButton {
    
    @IBInspectable var buttonBackgroundColor: UIColor = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var shadowOpacity: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateLayerProperties()
    }
    
    func updateLayerProperties() {
        layer.backgroundColor = buttonBackgroundColor.cgColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = CFloat(shadowOpacity)
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
    
}
