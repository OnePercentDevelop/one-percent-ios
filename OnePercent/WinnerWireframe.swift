//
//  WinnerWireframe.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 4. 27..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation
import UIKit

let winnerViewControllerIdentifier = "WinnerViewController"
let calendarViewControllerIdentifier = "CalendarViewController"

class WinnerWireframe: NSObject {
    weak var winnerViewController: WinnerViewController!
    var calendarWireframe: CalendarWireframe!
    
    // MARK: - function
    func presentWinnerInterfaceFromWindow(viewController: WinnerViewController) {
        let presenter = WinnerPresenter()
        let wireframe = WinnerWireframe()
        let interactor = WinnerInteractor()
        
        viewController.presenter = presenter
        
        presenter.view = viewController
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        
        wireframe.winnerViewController = viewController
    
        interactor.output = presenter
    }

    func winnerViewControllerFromStoryboard() -> WinnerViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: winnerViewControllerIdentifier) as! WinnerViewController
        return viewController
    }
    
    func calendarViewControllerFromStoryboard() -> CalendarViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: calendarViewControllerIdentifier) as! CalendarViewController
        return viewController
    }
}

// MARK: - WinnerWireframeInputProtocol
extension WinnerWireframe: WinnerWireframeInputProtocol {
    func presentationCalendarInterfaceForWinner(from view: WinenrViewInterfaceProtocol) {
        let calendarViewController = calendarViewControllerFromStoryboard()
        
        if let sourceView = view as? WinnerViewController {
            sourceView.present(calendarViewController, animated: true, completion: nil)
        }
    }
    
    func presentationSignUpAlertView() {
        signUpAlert(viewController: winnerViewController)
    }
}
