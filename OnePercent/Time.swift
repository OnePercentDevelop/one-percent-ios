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
//    private let voteStartTime = NSCalendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())
//    private let voteEndTime = NSCalendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())
//    private let anounceStartTime = NSCalendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())
    let dateFomatter = DateFormatter()
    
    
    private let voteStartTime = NSCalendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
    private let voteEndTime = NSCalendar.current.date(bySettingHour: 0, minute: 2, second: 0, of: Date())
    private let anounceStartTime = NSCalendar.current.date(bySettingHour: 0, minute: 4, second: 0, of: Date())
    private var tomorrowVoteStartTime = NSCalendar.current.date(byAdding: .day, value: 1, to: Date())
    private let appStartDate: Date!

    static let sharedInstance: Time = {
        let instance = Time()
        return instance
    }()
    
    init() {
        tomorrowVoteStartTime = NSCalendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: tomorrowVoteStartTime!)
        dateFomatter.dateFormat = "yyyy.MM.dd"
        appStartDate = dateFomatter.date(from: "2016.12.17")
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
    
    public func getAppStartDate() -> Date {
        return appStartDate
    }
    
    public func getAppStartStringDate() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy년MM월dd일"
        return format.string(from: appStartDate)
    }

    public func dateyyyyMM(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy년MM월"
        return format.string(from: date)
    }

    public func dateyyyyMMdd(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy년MM월dd일"
        return format.string(from: date)
    }
    
    public func stringFromDateDotyyyyMMdd(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy.MM.dd"
        return format.string(from: date)
    }
    
    public func stringFromDateNoneyyyyMMdd(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        return format.string(from: date)
    }
    
    public func dateFromStringDotyyyyMMdd(date: String) -> Date {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        return format.date(from: date)!
    }
    


    func stringFromTimeInterval(interval:TimeInterval) -> String {
        let ti = Int(interval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    

}
