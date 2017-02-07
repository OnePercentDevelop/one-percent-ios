//
//  Example.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 1. 31..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation
protocol Initable {
    init()
}

extension Int: Initable {}

extension String: Initable {}

class Example<T: Initable> {
    var grid: [T]
    
    init() {
        grid = Array(repeating: T(), count: 4)
    }
    
    func indexIsValidForRow(index: Int) -> Bool {
        return index >= 0 && index < 4
    }
    
    subscript(index: Int) -> T {
        get {
            assert(indexIsValidForRow(index: index),"Index out of range")
            return grid[index]
        }
        set {
            assert(indexIsValidForRow(index: index),"Index out of range")
            grid[index] = newValue
        }
    }

}
