//
//  CalendarNavigationView.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 2. 16..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import UIKit

class CalendarNavigationView: UIView {

    
    
    @IBOutlet weak var moveToYesterDayButton: UIButton!
    
    @IBOutlet weak var openCalendarButton: UIButton!
    
    @IBOutlet weak var moveToTomorrowButton: UIButton!
    
//    @IBAction func moveToYesterDayButton(_ sender: Any) {
//        let selectedDate = openCalendarButton.currentTitle
//        print("openCalendarButton.currentTitle>> \(openCalendarButton.currentTitle)")
//        
////        let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Time.sharedInstance.dateFomatter.date(from: selectedDate!)!)// dateFormatter.date(from: selectedDate!)!)
////        let yesterdayString = dateFormatter.string(from: yesterDay!)
////        
////        reloadOpenCalendarView(selectedDate: yesterdayString)
//    }
    
    @IBAction func openCalendarButton(_ sender: Any) {
        
    }
    
    @IBAction func moveToTomorrowButton(_ sender: Any) {
    }
    
    
    func reloadOpenCalendarView(selectedDate: String) {
//        self.selectedDate = selectedDate
        openCalendarButton.setTitle(selectedDate, for: .normal)
//        let dateSelectedDate = Time.sharedInstance.dateFomatter.date(from: selectedDate)//dateFormatter.date(from: selectedDate)//Time.sharedInstance.dateFromStringDotyyyyMMdd(date: selectedDate)//Time.sharedInstance.dateFomatter.date(from: selectedDate)
        
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
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CalendarNavigationView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    
}
