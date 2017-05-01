//
//  WinnerPresenter.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 4. 27..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation

class WinnerPresenter: WinnerFromInteractorToPresenterProtocol,WinnerFromViewToPresenterProtocol {
    // Reference to the View (weak to avoid retain cycle).
    weak var view: WinenrViewInterfaceProtocol!
    
    // Reference to the Interactor's interface.
    var interactor: WinnerInteractorInputProtocol!
    
    // Reference to the Router
    var wireframe: WinnerWireframeInputProtocol!
    
    // MARK: - WinnerFromInteractorToPresenterProtocol
    func updateView(date: String) {
        self.interactor.fetchWinners(selectedDate: date)
    }
    
    func showCalendar(date: String) {
        self.wireframe.presentationCalendarInterfaceForWinner(date: date)
    }
    
//    func showAllWinners() {
//        //TODO: 보여줄 count 변경
//    }
    
    // MARK: - WinnerFromViewToPresenterProtocol
    func winnersFetched(winners: [String]) {
        // TODO
        self.view.showWinnerData(winners: winners)
    }
   
    func giftFetched(gift: Gift) {
        // TODO
        self.view.showGiftData(gift: gift)
    }
}
