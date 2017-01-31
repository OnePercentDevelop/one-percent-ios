//
//  CalendarViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 12. 27..
//  Copyright © 2016년 김혜원. All rights reserved.
//

// TODO: 필요없는 코드 삭제

import UIKit
import CVCalendar

class CalendarViewController: UIViewController {
    // TODO: Seugue로보낸 selectedDate 색칠 -> presentedDateUpdated()
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBAction func selectDoneButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
        if let day = selectedDay {
            selectedDate = day.date.commonDescriptionYYMMddDot
        }
       
        _ = delegate?.dateSelectDone(date: selectedDate!)
    }
    
    @IBOutlet weak var monthLabel: UILabel!

    var todayDate = String()
    var delegate: CalendarViewControllerDelegate?
    
    // MARK: - Calendar Property
    var currentCalendar: Calendar?
    var selectedDay:DayView!
    var animationFinished = true
    var selectedDate: String?
    
    // MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayDate = Time.sharedInstance.dateFomatter.string(from: Date())

        monthLabel.text = Time.sharedInstance.dateyyyyMM(date: Date())
        
        //calendar
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        
        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
        
        disablePreviousDays()
        disableAfterDays()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.dismiss(animated: true, completion: nil)
    }

    
    
    func disablePreviousDays() {
        // TODO: appStartDate 한번만 선언할수있게
        
        let calendar = Calendar.current
        
        for weekV in calendarView.contentController.presentedMonthView.weekViews {
            for dayView in weekV.dayViews {
                if calendar.compare(dayView.date.convertedDate(calendar: calendar)!, to: Time.sharedInstance.getAppStartDate(), toGranularity: .day) == .orderedAscending {
                    dayView.isUserInteractionEnabled = false
                    dayView.dayLabel.textColor = calendarView.appearance.dayLabelWeekdayOutTextColor
                }
            }
        }
    }
    
    func disableAfterDays() {
        let calendar = Calendar.current
        for weekV in calendarView.contentController.presentedMonthView.weekViews {
            for dayView in weekV.dayViews {
                if calendar.compare(dayView.date.convertedDate(calendar: calendar)!, to: Date(), toGranularity: .day) == .orderedDescending {
                    dayView.isUserInteractionEnabled = false
                    dayView.dayLabel.textColor = calendarView.appearance.dayLabelWeekdayOutTextColor
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate
extension CalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    // MARK: Optional methods
    func calendar() -> Calendar? {
        return currentCalendar
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        selectedDay = dayView
    }
    
    func shouldSelectRange() -> Bool {
        return false
    }
    //줄사이 라인
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    //오늘날짜에 동그라미쳐짐
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescriptionYYMM && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescriptionYYMM
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }

        disablePreviousDays()
        disableAfterDays()
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
}

// MARK: - IB Actions
extension CalendarViewController {
    @IBAction func gotoTodayButton() {
        self.calendarView.toggleCurrentDayView()
    }
}


// MARK: - Convenience API Demo
extension CalendarViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        guard let currentCalendar = currentCalendar else {
            return
        }
        var components = Manager.componentsForDate(Foundation.Date(), calendar: currentCalendar) // from today
        
        components.month! = components.month! + offset
        
        let resultDate = currentCalendar.date(from: components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
}

// MARK: -protocol
protocol CalendarViewControllerDelegate {
    func dateSelectDone(date: String)
}
