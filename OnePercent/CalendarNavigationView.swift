//
//  CalendarNavigationView.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 2. 16..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import UIKit

class CalendarNavigationView: UIView {
    //MARK: - IBOutlet
    @IBOutlet weak var moveToYesterDayButton: UIButton!
    @IBOutlet weak var openCalendarButton: UIButton!
    @IBOutlet weak var moveToTomorrowButton: UIButton!

    //MARK: - IBAction
    @IBAction func openCalendarButton(_ sender: Any) {
        
    }

    @IBAction func moveToTomorrowButton(_ sender: Any) {
    }
    
    //MARK: - function
    func reloadOpenCalendarView(selectedDate: String) {
        openCalendarButton.setTitle(selectedDate, for: .normal)
        if Time.sharedInstance.dateFomatter.date(from: selectedDate)?.compare(Time.sharedInstance.getAppStartDate()) == ComparisonResult.orderedSame {
            moveToYesterDayButton.isHidden = true
        } else {
            moveToYesterDayButton.isHidden = false
        }
        
        // TODO: 날짜비교로 수정하기
        if selectedDate == Time.sharedInstance.dateFomatter.string(from: Date()) {
            moveToYesterDayButton.isHidden = true
        } else {
            moveToYesterDayButton.isHidden = false
        }
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CalendarNavigationView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
