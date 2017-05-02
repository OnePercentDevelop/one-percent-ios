//
//  WinnerProtocol.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 4. 27..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation
//view
protocol WinenrViewInterfaceProtocol: class {
    func showWinnerData(winners: [String])
    func showGiftData(gift: Gift)
    func setCalendarNavigationUI(selectedDate date: String)
}

//presenter
protocol WinnerFromViewToPresenterProtocol {
    func updateView(date: String)
    func showCalendar(date: String)
    func showAllWinnersDidClick()
    func moveToYesterDayDidClick()
    func calendarOpenButtonClick(winnerViewController: WinnerViewController)
    func moveToTomorrowDidClick()
    func viewDidLoad()
}

protocol WinnerFromInteractorToPresenterProtocol: class {
    func winnersFetched(winners: [String])
    func giftFetched(gift: Gift)
}

//interactor
protocol WinnerInteractorInputProtocol: class {
    func fetchWinnersAndGift(selectedDate date: String)
}

//wireframe
protocol WinnerWireframeInputProtocol {
    func presentationCalendarInterfaceForWinner(from view: WinenrViewInterfaceProtocol)
    func presentationSignUpAlertView()
}

