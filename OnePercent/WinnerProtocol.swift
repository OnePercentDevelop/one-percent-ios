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
}

//presenter
protocol WinnerFromViewToPresenterProtocol {
    func updateView(date: String) // yesterday, tomorrow, selected date 포함
    func showCalendar(date: String)
//    func showAllWinners()
}

protocol WinnerFromInteractorToPresenterProtocol: class {
    func winnersFetched(winners: [String])
    func giftFetched(gift: Gift)
}

//interactor
protocol WinnerInteractorInputProtocol: class {
    func fetchWinners(selectedDate date: String)
}

//wireframe
protocol WinnerWireframeInputProtocol {
    func presentationCalendarInterfaceForWinner(date: String)
}

