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

    func installWinnerViewControllerIntoWindow(winnerViewController: WinnerViewController) {
        winnerWireframe.presentWinnerInterfaceFromWindow(viewController: winnerViewController)
    }
}
