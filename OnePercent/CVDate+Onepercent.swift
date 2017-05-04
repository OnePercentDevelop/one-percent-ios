//
//  CVDate + Onepercent.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 5. 2..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation
import CVCalendar

extension CVDate {
    public var globalDescriptionYYMM: String? {
        guard let date = convertedDate(calendar: Calendar.current) else {
            return nil
        }
        let month = dateFormattedStringWithFormat("MM", fromDate: date)
        
        return "\(year)년 \(month)월"
    }
    
    public var commonDescriptionYYmmddKorean: String? {
        guard let date = convertedDate(calendar: Calendar.current) else {
            return nil
        }
        let month = dateFormattedStringWithFormat("MM", fromDate: date)
        
        return "\(year)년\(month)월\(day)일"
    }
    
    public var commonDescriptionYYMMddDot: String? {
        guard let date = convertedDate(calendar: Calendar.current) else {
            return nil
        }
        let month = dateFormattedStringWithFormat("MM", fromDate: date)
        let day = dateFormattedStringWithFormat("dd", fromDate: date)
        
        return "\(year).\(month).\(day)"
    }
}

private extension CVDate {
    func dateFormattedStringWithFormat(_ format: String, fromDate date: Foundation.Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
