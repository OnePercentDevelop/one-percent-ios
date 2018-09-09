//
//  WinnerPresenter.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 4. 27..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
//import SwiftDate

class WinnerPresenter {
    
    weak var view: WinenrViewInterfaceProtocol!
    var interactor: WinnerInteractorInputProtocol!
    var wireframe: WinnerWireframeInputProtocol!
    
    // MAKR: - Property
//    var selectedDate: String = Date().string(with: .dotyyyyMMdd) {
//        didSet {
//            isExtended = false
//        }
//    }
    //위주석대신임시
    var selectedDate = "2018.08.31"
//    var todayDate: String { return Date().string(with: .dotyyyyMMdd) }
    //위주석대신임시
    var todayDate = "2018.08.30"
    
    var winners: [String] = []
    var isExtended: Bool = false
    
    var winnersCount: Int { return (isExtended ? winners.count : min(minimumPresentingCount, winners.count)) }
    var winnersCollectionHeaderText: String { return "\(winners.count) 명" }
    var isExtendedButtonHidden: Bool { return winners.count < minimumPresentingCount || isExtended }
    
    fileprivate func setCalendarNavigationUI(selectedDate date: String) {
        view.dateTitle = date
        if date == todayDate {
            view.isMoveToTomorrowButtonHidden = true
        } else if date == Time.sharedInstance.getAppStartStringDate() {
            view.isMoveToYesterdayButtonHidden = true
        } else {
            view.isMoveToTomorrowButtonHidden = false
            view.isMoveToYesterdayButtonHidden = false
        }
    }
    
    fileprivate func setWinnerViewUI(selectedDate: String) {
        if selectedDate == todayDate {
            if Date() < Time.sharedInstance.getAnounceStartTime() {
                view.isBeforeAnounceViewHidden = false
            } else {
                view.isBeforeAnounceViewHidden = true
            }
        } else {
            view.isBeforeAnounceViewHidden = true
        }
    }
    
}

// MARK: - WinnerFromViewToPresenterProtocol
extension WinnerPresenter: WinnerFromViewToPresenterProtocol {
    
    func viewDidLoad() {
        setCalendarNavigationUI(selectedDate: selectedDate)
        setWinnerViewUI(selectedDate: selectedDate)
        view.setWinnersCollectionExtended(isExtended)
        
        interactor.fetchWinnersAndGift(selectedDate: selectedDate)
    }
    
    func bind(_ cell: WinnerCollectionViewCell, at row: Int) {
        cell.winnerIdLabel.text = winners[row]
        if winners[row] == Defaults[.id] {
            cell.winnerIdLabel.tintColor = UIColor.red
        } else {
            cell.winnerIdLabel.tintColor = UIColor.black
        }
    }
    
    func showAllWinnersDidClick() {
        isExtended = true
        view.setWinnersCollectionExtended(isExtended)
        view.reloadWinnersCollection()
    }
    
    func moveToYesterDayDidClick() {
        guard Defaults[.isSignIn] else {
            wireframe.presentationSignUpAlertView()
            return
        }
        
        //어제 날짜 계산해 selectedDate 값으로 초기화
        let selectedDateObj = self.selectedDate.date(with: .dotyyyyMMdd)
//        let yesterDay = selectedDateObj.add(components: [.day: -1])
        
//        selectedDate = yesterDay.string(with: .dotyyyyMMdd)
        //위두문장대신임시
        selectedDate = "2018.09.01"
        
        
        //navigation ui 변경
        setCalendarNavigationUI(selectedDate: selectedDate)
        setWinnerViewUI(selectedDate: selectedDate)
        
        //interactor 날짜 전달하여 데이터 불러오게하기
        interactor.fetchWinnersAndGift(selectedDate: selectedDate)
    }
    
    func moveToTomorrowDidClick() {
        guard Defaults[.isSignIn] else {
            wireframe.presentationSignUpAlertView()
            return
        }
        let selectedDateObj = selectedDate.date(with: .dotyyyyMMdd)
        //let tomorrow = selectedDateObj.add(components: [.day: 1])
        
        //selectedDate = tomorrow.string(with: .dotyyyyMMdd)
        //위두문장대신 임시
        selectedDate = "2018.09.01"
        
        
        setCalendarNavigationUI(selectedDate: selectedDate)
        setWinnerViewUI(selectedDate: selectedDate)
        
        interactor.fetchWinnersAndGift(selectedDate: selectedDate)
    }
    
    func calendarOpenButtonClick(winnerViewController: WinnerViewController) {
        if Defaults[.isSignIn] {
            self.wireframe.presentationCalendarInterfaceForWinner(from: view)
        } else {
            self.wireframe.presentationSignUpAlertView()
        }
    }
    
    func calendarVCDelegateDateSelectDoneClick(date: String) {
        selectedDate = date
        
        setCalendarNavigationUI(selectedDate: selectedDate)
        setWinnerViewUI(selectedDate: selectedDate)
        
        interactor.fetchWinnersAndGift(selectedDate: selectedDate)
    }
    
}

// MARK: - WinnerFromInteractorToPresenterProtocol
extension WinnerPresenter: WinnerFromInteractorToPresenterProtocol {
    
    func winnersFetched(winners: [String]) {
        self.winners = winners
        view.setWinnersCollectionExtended(isExtended)
        view.reloadWinnersCollection()
    }
    
    func giftFetched(gift: Gift) {
        view.showGiftData(gift: gift)
    }
    
}
