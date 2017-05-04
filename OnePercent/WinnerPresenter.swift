//
//  WinnerPresenter.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 4. 27..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class WinnerPresenter {
    weak var view: WinenrViewInterfaceProtocol!
    var interactor: WinnerInteractorInputProtocol!
    var wireframe: WinnerWireframeInputProtocol!
    var calendarViewController: CalendarViewController?
    
    // MAKR: - Property
    var selectedDate: String!
    var todayDate: String {
        return Time.sharedInstance.stringFromDateDotyyyyMMdd(date: Date())
    }

    // MARK: - Internal Function
    internal func calendarNavigationViewFetched(date: String) {
        self.view.setCalendarNavigationUI(selectedDate: date)
    }
    
    internal func winnerViewControllerFetched(date: String) {
        self.view.setWinnerViewUI(selectedDate: date)
    }
    
    func presentWinnersCount(isExtend : Bool, count: Int) -> Int {
        var presentWinnersCount: Int = 0
        if isExtend {
            presentWinnersCount = count
        } else {
            if count > minimumPresentingCount {
                presentWinnersCount = minimumPresentingCount
            } else {
                presentWinnersCount = count
            }
        }
        return presentWinnersCount
    }
}

// MARK: - WinnerFromInteractorToPresenterProtocol
extension WinnerPresenter: WinnerFromInteractorToPresenterProtocol {
    func winnersFetched(winners: [String]) {
        let cellCount = presentWinnersCount(isExtend: false, count: winners.count)
        self.view.setPresentWinnersCount(cellCount: cellCount)
        self.view.setWinnerCollectionViewUI(cellCount: cellCount)
        self.view.showWinnerData(winners: winners)
    }
    
    func giftFetched(gift: Gift) {
        self.view.showGiftData(gift: gift)
    }
}

// MARK: - WinnerFromViewToPresenterProtocol
extension WinnerPresenter: WinnerFromViewToPresenterProtocol {
    func showAllWinnersDidClick(winnersCount: Int) {
        let count = presentWinnersCount(isExtend: true, count: winnersCount)
        self.view.setPresentWinnersCount(cellCount: count)
        self.view.setWinnerCollectionViewUI(cellCount: count)
    }
    
    func moveToYesterDayDidClick() {
        //로그인 되어있는지 확인하기
        if Defaults[.isSignIn] {
            //어제 날짜 계산해 selectedDate 값으로 초기화
            let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Time.sharedInstance.dateFromStringDotyyyyMMdd(date: selectedDate))
            selectedDate = Time.sharedInstance.stringFromDateDotyyyyMMdd(date: yesterDay!)
            
            //navigation ui 변경
            calendarNavigationViewFetched(date: selectedDate)
            self.view.setWinnerViewUI(selectedDate: selectedDate)

            //interactor 날짜 전달하여 데이터 불러오게하기
            self.interactor.fetchWinnersAndGift(selectedDate: selectedDate)
        } else {
            //signUpAlert present
            self.wireframe.presentationSignUpAlertView()
        }
    }
    
    func calendarOpenButtonClick(winnerViewController: WinnerViewController) {
        if Defaults[.isSignIn] {
            self.wireframe.presentationCalendarInterfaceForWinner(from: view)
        } else {
            self.wireframe.presentationSignUpAlertView()
        }
    }
    
    func moveToTomorrowDidClick() {
        if Defaults[.isSignIn] {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Time.sharedInstance.dateFromStringDotyyyyMMdd(date: selectedDate))
            selectedDate = Time.sharedInstance.stringFromDateDotyyyyMMdd(date: tomorrow!)
            calendarNavigationViewFetched(date: selectedDate)
            self.view.setWinnerViewUI(selectedDate: selectedDate)
            self.interactor.fetchWinnersAndGift(selectedDate: selectedDate)
        } else {
            self.wireframe.presentationSignUpAlertView()
        }
    }
    
    func viewDidLoad() {
        selectedDate = todayDate
        calendarNavigationViewFetched(date: todayDate)
        self.view.setWinnerViewUI(selectedDate: todayDate)
        self.view.setWinnerCollectionViewUI(cellCount: minimumPresentingCount)
        self.interactor.fetchWinnersAndGift(selectedDate: todayDate)
    }
    
    func calendarVCDelegateDateSelectDoneClick(date: String) {
        selectedDate = date
        calendarNavigationViewFetched(date: selectedDate)
        self.view.setWinnerViewUI(selectedDate: selectedDate)
        self.interactor.fetchWinnersAndGift(selectedDate: selectedDate)
    }
}
