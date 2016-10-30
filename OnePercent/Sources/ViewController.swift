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

    // MARK: - Property
    @IBOutlet weak var timeLabel: UILabel!
    var timer: Timer?
    let voteStartTime = NSCalendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())
    let voteEndTime = NSCalendar.current.date(bySettingHour: 12, minute: 59, second: 59, of: Date())
    let anounceStartTime = NSCalendar.current.date(bySettingHour: 18, minute: 45, second: 0, of: Date())
    //var tomorrowVoteStartTime = NSCalendar.current.date(byAdding: .day, value: 1, to: Date())
    //tomorrow = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: tomorrow!)
    // MARK: - IBAction
    
    // MARK: - FilePrivate Function
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
        dateformat()
    }
    
    fileprivate func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Recycle Function
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
    
    // MARK: - Personal Function
    func dateformat() {
        let calendar = NSCalendar.current
        var tomorrowVoteStartTime = calendar.date(byAdding: .day, value: 1, to: Date())
        tomorrowVoteStartTime = calendar.date(bySettingHour: 11, minute: 0, second: 0, of: tomorrowVoteStartTime!)
        //let remainingTime = stringFromTimeInterval(interval: tomorrow!.timeIntervalSince(Date()))
        var remainingTime = ""
        let now = Date()
        if now > voteStartTime! && now < voteEndTime! {
            remainingTime = "투표종료까지 남은시간 : " + stringFromTimeInterval(interval: voteEndTime!.timeIntervalSince(Date()))
        } else if now < voteStartTime! {
            remainingTime = "투표시작까지 남은시간 : " + stringFromTimeInterval(interval: voteStartTime!.timeIntervalSince(Date()))
        } else  if now < anounceStartTime! {
            remainingTime = "발표시작까지 남은시간 : " + stringFromTimeInterval(interval: anounceStartTime!.timeIntervalSince(Date()))
        } else {
            remainingTime = "내일 투표시작까지 남은시간 : " + stringFromTimeInterval(interval: tomorrowVoteStartTime!.timeIntervalSince(Date()))

        }
        
        timeLabel.text = remainingTime

        
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    func stringFromTimeInterval(interval:TimeInterval) -> String {
        let ti = Int(interval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }

}

