//
//  CalendarViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 12. 27..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBAction func selectDoneButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        _ = delegate?.dateSelectDone(date: selectedDate!)
//        print("date: \(selectedDate)")
//        print("date: \(de)")
        // TODO: segue 통해서 정한 날짜 이전 화면으로 데이터 전송
    }
    @IBOutlet weak var monthLabel: UILabel!

    let dateFormatter = DateFormatter()
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
        
        dateFormatter.dateFormat = "yyyy년MM월dd일"
        todayDate = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat = "yyyy년MM월"
        monthLabel.text = dateFormatter.string(from: Date())
        
        //calendar
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        
        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
        // Do any additional setup after loading the view.
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        print("didSelectDayView")
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
        selectedDate = date.commonDescriptionYYmmdd
        print("selectedDay >> " + "\(date.commonDescriptionYYmmdd)" + ">>" + "\(selectedDate)")
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

