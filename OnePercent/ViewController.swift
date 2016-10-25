//
//  ViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 10. 24..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import UIKit
import SwiftyTimer

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    var timer: Timer?

    fileprivate func startTimer() {
        if timer != nil {
            stopTimer()
        }
        
        self.updateTodayLeftTime()
        timer = Timer.new(every: 0.5.second, updateTodayLeftTime)
        timer?.start()
    }
    
    fileprivate func updateTodayLeftTime() {
    //viewController?.todayLeftTimeSecond = interactor.todayLeftSecond
//        print("a\(Date())")
        
    dateformat()
        
      //timeLabel.text = "\(Date())"
    }
    
    fileprivate func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    func dateformat() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let dateTime = formatter.string(from: Date())
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let onTime = dateFormatter.string(from: Date())
        
        let cal = NSCalendar(calendarIdentifier:NSCalendar.Identifier(rawValue: NSGregorianCalendar))!
        //cal.date(byAdding: <#T##DateComponents#>, to: <#T##Date#>, options: <#T##NSCalendar.Options#>)
        
        //print(dateTime)
        
//        let deformatter = DateFormatter()
//        deformatter.dateFormat = "hh:mm:ss"
//
//        let onTime = "11:00:00"
//        let timeFromDate = deformatter.date(from: onTime)
//        print(timeFromDate)
        /*
         let calendar = NSCalendar.currentCalendar()
         
         // Replace the hour (time) of both dates with 00:00
         let date1 = calendar.startOfDayForDate(firstDate)
         let date2 = calendar.startOfDayForDate(secondDate)
         
         let flags = NSCalendarUnit.Day
         let components = calendar.components(flags, fromDate: date1, toDate: date2, options: [])
         
         components.day
         */
//        let calendar = Calendar.current
//        
//        let date1 = calendar.startOfDay(for: Date())
//        let date2 = calendar.startOfDay(for: timeFromDate!)
//        //let date2 = calendar.startOfDay(for: Date())
//        //let flags = CFCalendarUnit.day
////        
////        let components = calendar.dateComponents([.minute], from: date2, to: date1)
////        print(components.minute!)
//        let remainingTime = date1.timeIntervalSince(date2)
//        let t = stringFromTimeInterval(interval: remainingTime)
//        //print(t)

    }
    
    func stringFromTimeInterval(interval:TimeInterval) -> String {
        
        let ti = Int(interval)
        //print(ti)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }

}

