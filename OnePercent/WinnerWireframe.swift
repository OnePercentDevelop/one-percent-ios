//
//  WinnerWireframe.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 4. 27..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation
import UIKit
let WinnerViewControllerIdentifier = "WinnerViewController"

class WinnerWireframe: NSObject, WinnerWireframeInputProtocol {
    weak var winnerViewController: WinnerViewController!
    
    var winnerPresenter = WinnerPresenter()
    // MARK: - WinnerWireframeInputProtocol
    func presentationCalendarInterfaceForWinner(date: String) {
                
        // TODO calendarWireFrame 초기화, date 전달, calendar view 화면 present
                //present(calendarViewController!, animated: true, completion: nil)
        
    }
    
    func presentWinnerInterfaceFromWindow(window: UIWindow) {
        let viewController = winnerViewControllerFromStoryboard()
        viewController.presenter = winnerPresenter
        winnerViewController = viewController
        winnerPresenter.view = viewController
    }

    func winnerViewControllerFromStoryboard() -> WinnerViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: WinnerViewControllerIdentifier) as! WinnerViewController
        return viewController
    }
    
    // MARK: - Private
//    private func sendDateToCalendarPresenter() {//(calendarPresenter: CalendarPresenter, date: Date) {
////        calendarPresenter.date = date
//
//    }
    
    
}
