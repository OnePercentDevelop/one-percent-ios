//
//  WinnerInteractor.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 4. 27..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

class WinnerInteractor {
    //MARK: - Property
    weak var output: WinnerFromInteractorToPresenterProtocol!
    
    // MARK: - Internal
    internal func getWinnersArray(selectedDate: String) -> [String] {
        guard let winners = uiRealm.objects(Prize.self).filter("prizeDate == '\(selectedDate)'").last?.winner else {
            return []
        }
        return winners.components(separatedBy: " ")
    }
    
    internal func fetchGift(selectedDate: String) {
        Alamofire
            .request("http://onepercentserver.azurewebsites.net/OnePercentServer/todayGift.do?vote_date=\(selectedDate)", method: .get)
            .log(level: .verbose)
            .responseObject { [weak self] (response: DataResponse<GiftResponse>) in
                guard let giftResponse = response.result.value?.giftResult?.first, let giftName = giftResponse.giftName, let giftPng = giftResponse.giftPng else  {
                    return
                }
                let gift = Gift(name: giftName, url: "http://onepercentserver.azurewebsites.net/OnePercentServer/resources/common/image/" + giftPng)
                self?.output.giftFetched(gift: gift)
            }
    }
    
}

// MARK: - WinnerInteractorInputProtocol
extension WinnerInteractor: WinnerInteractorInputProtocol {
    func fetchWinnersAndGift(selectedDate date: String) {
        let winnersArray = getWinnersArray(selectedDate: date)
        output.winnersFetched(winners: winnersArray)
        fetchGift(selectedDate: date)
    }
}




