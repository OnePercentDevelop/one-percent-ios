//
//  Time.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 1. 5..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation
import SwiftyTimer
import UIKit

class Time {
    var timer: Timer?
 
//    private let voteStartTime = NSCalendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())
//    private let voteEndTime = NSCalendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())
//    private let anounceStartTime = NSCalendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())

    private let voteStartTime = NSCalendar.current.date(bySettingHour: 17, minute: 38, second: 0, of: Date())
    private let voteEndTime = NSCalendar.current.date(bySettingHour: 18, minute: 35, second: 0, of: Date())
    private let anounceStartTime = NSCalendar.current.date(bySettingHour: 19, minute: 36, second: 0, of: Date())
    private var  tomorrowVoteStartTime = NSCalendar.current.date(byAdding: .day, value: 1, to: Date())

    
    private var nowStateText: String = ""
    private var timeBeforeStateText: String = ""
    private var timeBeforeText: String = ""
    
    
    static let sharedInstance: Time = {
        let instance = Time()
        return instance
    }()
    
    init() {
        tomorrowVoteStartTime = NSCalendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: tomorrowVoteStartTime!)
    }
    
    func dateformat() {
        let calendar = NSCalendar.current
        var tomorrowVoteStartTime = calendar.date(byAdding: .day, value: 1, to: Date())
        tomorrowVoteStartTime = calendar.date(bySettingHour: 11, minute: 0, second: 0, of: tomorrowVoteStartTime!)
        let now = Date()
        
        if now > voteStartTime! && now < voteEndTime! {
            timeBeforeStateText = "투표종료까지 남은시간"
            nowStateText = "투표중"
            timeBeforeText = stringFromTimeInterval(interval: voteEndTime!.timeIntervalSince(Date()))
        } else if now < voteStartTime! {
            timeBeforeStateText = "투표시작까지 남은시간"
            nowStateText = "투표대기중"
            timeBeforeText = stringFromTimeInterval(interval: voteStartTime!.timeIntervalSince(Date()))
        } else  if now < anounceStartTime! {
            timeBeforeStateText = "발표시작까지 남은시간"
            nowStateText = "결과 집계 중"
            timeBeforeText = stringFromTimeInterval(interval: anounceStartTime!.timeIntervalSince(Date()))
        } else {
            timeBeforeStateText = "내일 투표시작까지 남은시간"
            nowStateText = "당첨자발표중"
            timeBeforeText = stringFromTimeInterval(interval: tomorrowVoteStartTime!.timeIntervalSince(Date()))
        }
    }
    
    public func getVoteStartTime() -> Date {
        return voteStartTime!
    }
    
    public func getVoteEndTime() -> Date {
        return voteEndTime!
    }

    public func getAnounceStartTime() -> Date {
        return anounceStartTime!
    }
    
    public func getTomorrowVoteStartTime() -> Date {
        return tomorrowVoteStartTime!
    }

//    public func getTimeBeforeStateText() -> String {
//        return timeBeforeStateText
//    }
//    
//    public func getNowStateText() -> String {
//        return nowStateText
//    }
//    
//    public func getTimeBeforeText() -> String {
//        return timeBeforeText
//    }
    
    func stringFromTimeInterval(interval:TimeInterval) -> String {
        let ti = Int(interval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    

}
