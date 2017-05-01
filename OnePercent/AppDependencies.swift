//
//  AppDependencies.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 5. 1..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation
import UIKit

class AppDependencies {
    var winnerWireframe = WinnerWireframe()
    
    init() {
        configureDependencies()
    }
    
    func installRootViewControllerIntoWindow(window: UIWindow) {
        winnerWireframe.presentWinnerInterfaceFromWindow(window: window)
    }
    
    func configureDependencies() {
        
        let winnerPresenter = WinnerPresenter()
        let winnerInteractor = WinnerInteractor()

        winnerInteractor.output = winnerPresenter
        
        winnerPresenter.interactor = winnerInteractor
        winnerPresenter.wireframe = winnerWireframe
        
        //calendar wireframe set
        winnerWireframe.winnerPresenter = winnerPresenter
        
        
    }
}
