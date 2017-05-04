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
    
    // MAKR: - Property
    var selectedDate: String!
    var todayDate: String {
        return Time.sharedInstance.stringFromDateDotyyyyMMdd(date: Date())
    }
    var calendarViewController: CalendarViewController?

    // MARK: - Internal Function
    internal func calendarNavigationViewFetched(date: String) {
        self.view.setCalendarNavigationUI(selectedDate: date)
    }
    
    internal func winnerViewControllerFetched(date: String) {
        self.view.setWinnerViewUI(selectedDate: date)
    }
}

// MARK: - WinnerFromInteractorToPresenterProtocol
extension WinnerPresenter: WinnerFromInteractorToPresenterProtocol {
    func winnersFetched(winners: [String]) {
        self.view.showWinnerData(winners: winners)
    }
    
    func giftFetched(gift: Gift) {
        self.view.showGiftData(gift: gift)
    }
}

// MARK: - WinnerFromViewToPresenterProtocol
extension WinnerPresenter: WinnerFromViewToPresenterProtocol {
    func updateView(date: String) {
        self.interactor.fetchWinnersAndGift(selectedDate: date)
    }
    
    func showCalendar(date: String) {
        //        self.wireframe.presentationCalendarInterfaceForWinner(date: date)
    }
    
    func showAllWinnersDidClick() {
        //TODO: collection view return cellcount 되는것 리턴숫자변경하기
        //TODO: view reload 되게하기
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
    }
    
    func calendarVCDelegateDateSelectDoneClick(date: String) {
        selectedDate = date
        calendarNavigationViewFetched(date: selectedDate)
        self.view.setWinnerViewUI(selectedDate: selectedDate)
        self.interactor.fetchWinnersAndGift(selectedDate: selectedDate)
    }
}
//
//extension WinnerPresenter: CalendarViewControllerDelegate {
//    func dateSelectDone(date: String) {
//        selectedDate = date
//        calendarNavigationViewFetched(date: selectedDate)
//        self.interactor.fetchWinnersAndGift(selectedDate: selectedDate)
//    }
//}
