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

class WinnerInteractor: WinnerInteractorInputProtocol {
    //MARK: - Property
    var todayDate: String {
        return Time.sharedInstance.stringFromDateDotyyyyMMdd(date: Date())
    }
    weak var output: WinnerFromInteractorToPresenterProtocol!
    
    // MARK: - WinnerInteractorInputProtocol
    func fetchWinners(selectedDate date: String) {
        output.winnersFetched(winners: getWinnersArray(selectedDate: date))
        if let gift = getGift(selectedDate: date) {
            output.giftFetched(gift: gift)
        }
    }

    // MARK: - Private
    private func getWinnersArray(selectedDate: String) -> [String] {
        if let winners = uiRealm.objects(Prize.self).filter("prizeDate == '\(selectedDate)'").last?.winner {
            return winners.components(separatedBy: ",")
        } else {
            return []
        }
    }
    
    private func getGift(selectedDate: String) -> Gift? {
        var gift: Gift?
        Alamofire
            .request("http://onepercentserver.azurewebsites.net/OnePercentServer/todayGift.do?vote_date=\(selectedDate)", method: .get)
            .log(level: .verbose)
            .responseObject { (response: DataResponse<GiftResponse>) in
                if let giftResponse = response.result.value?.giftResult {
                    for n in giftResponse {
                        guard let giftName = n.giftName  else {
                            return
                        }
                        guard let giftPng = n.giftPng else {
                            return
                        }
                        gift = Gift(name: giftName, url: "http://onepercentserver.azurewebsites.net/OnePercentServer/resources/common/image/" + giftPng)
                    }
                }
            }
        return gift
    }
    
}


