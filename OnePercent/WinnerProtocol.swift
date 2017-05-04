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
    
    var dateTitle: String? { get set }
    var isMoveToTomorrowButtonHidden: Bool { get set }
    var isMoveToYesterdayButtonHidden: Bool { get set }
    var isBeforeAnounceViewHidden: Bool { get set }
    
    func reloadWinnersCollection()
    func setWinnersCollectionExtended(_ isExtended: Bool)
    
    func showGiftData(gift: Gift)
    
}

//presenter
protocol WinnerFromViewToPresenterProtocol {
    
    var winnersCount: Int { get }
    var winnersCollectionHeaderText: String { get }
    var isExtendedButtonHidden: Bool { get }
    
    func viewDidLoad()
    func bind(_ cell: WinnerCollectionViewCell, at row: Int)
    
    func showAllWinnersDidClick()
    func moveToYesterDayDidClick()
    func moveToTomorrowDidClick()
    
    func calendarOpenButtonClick(winnerViewController: WinnerViewController)
    func calendarVCDelegateDateSelectDoneClick(date: String)
    
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

