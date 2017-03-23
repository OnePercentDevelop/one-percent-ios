//
//  ViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 10. 24..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import UIKit
import SwiftyTimer
import Alamofire
import AlamofireObjectMapper
import AlamofireImage

class ViewController: UIViewController {
    
    // MARK: - Property
    var timer: Timer?
    var todayDate: String {
        return Time.sharedInstance.stringFromDateDotyyyyMMdd(date: Date())
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeBeforeStateLabel: UILabel!
    @IBOutlet weak var nowStateLabel: UILabel!
    @IBOutlet weak var entryNumberLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var informationView: UIView!
    
    // MARK: - IBAction
    @IBAction func openInformatioinViewButton(_ sender: AnyObject) {
        informationView.isHidden = false
    }
    @IBAction func closeInformatioinViewButton(_ sender: AnyObject) {
        informationView.isHidden = true
    }
   
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
        dateformat()
    }
    
    fileprivate func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        setGiftImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
        setVoteNumber()
        informationView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    // MARK: - UI Set Function
    func dateformat() {
        var nowState = ""
        let now = Date()
        
        if now > Time.sharedInstance.getVoteStartTime() && now < Time.sharedInstance.getVoteEndTime() {
            timeBeforeStateLabel.text = "투표종료까지 남은시간"
            nowState = "투표 중"
            timeLabel.text = stringFromTimeInterval(interval: Time.sharedInstance.getVoteEndTime().timeIntervalSince(now))
            
        } else if now < Time.sharedInstance.getVoteStartTime() {
            timeLabel.text = stringFromTimeInterval(interval: Time.sharedInstance.getVoteStartTime().timeIntervalSince(now))
            timeBeforeStateLabel.text = "투표시작까지 남은시간"
            nowState = "투표 대기 중"
        } else  if now < Time.sharedInstance.getAnounceStartTime() {
            timeBeforeStateLabel.text = "발표시작까지 남은시간"
            nowState = "결과 집계 중"
            timeLabel.text = stringFromTimeInterval(interval: Time.sharedInstance.getAnounceStartTime().timeIntervalSince(now))
        } else {
            timeBeforeStateLabel.text = "내일 투표시작까지 남은시간"
            nowState = "당첨자발표중"
            timeLabel.text = stringFromTimeInterval(interval: Time.sharedInstance.getTomorrowVoteStartTime().timeIntervalSince(now))
        }
        nowStateLabel.text = nowState
    }
    
    func stringFromTimeInterval(interval:TimeInterval) -> String {
        let ti = Int(interval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
    // MARK: - Data Set Function
    func setVoteNumber() {
        let todayDate = Time.sharedInstance.dateyyyyMMdd(date: Date())
        let URL = "http://onepercentserver.azurewebsites.net/OnePercentServer/voteNumber.do"
        let parameters: Parameters = ["vote_date": todayDate]
        
        Alamofire
            .request(URL, parameters: parameters)
            .log(level:  .verbose)
            .responseObject { (response: DataResponse<OnePercentResponse>) in
                
                if let voteresult = response.result.value?.voteResult {
                    for n in voteresult {
                        if let number = n.number {
                            self.entryNumberLabel.text = String(number)
                        }
                    }
                }
        }
    }
    
    func setGiftImage() {
        Alamofire
            .request("http://onepercentserver.azurewebsites.net/OnePercentServer/todayGift.do?vote_date=\(todayDate)", method: .get)
            .log(level: .verbose)
            .responseObject { (response: DataResponse<GiftResponse>) in
                if let giftResponse = response.result.value?.giftResult {
                    for n in giftResponse {
                        if let giftName = n.giftName {
                            self.productLabel.text = giftName
                        }
                        if let giftPng = n.giftPng {
                            let url = "http://onepercentserver.azurewebsites.net/OnePercentServer/resources/common/image/" + giftPng
                            self.productImageView.af_setImage(withURL: NSURL(string: url) as! URL)
                        }
                    }
                }
        }
    }


}

