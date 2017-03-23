//
//  WinnerViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 2. 16..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Alamofire
import CVCalendar
import RealmSwift

class WinnerViewController: UIViewController {
    var calendarViewController: CalendarViewController?

    //MARK: - Property
    var sixTestInfo: [String] = []
    var showMoreFlag: Bool = false
    let dateFormatter = DateFormatter()
    var selectedDate: String!
    var winnerArray:[String] = []
    var todayDate: String {
        return dateFormatter.string(from: Date())
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var winnerCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var winnerCollectionView: UICollectionView!
    @IBOutlet weak var beforeAnounceView: UIView!
    
    
    @IBOutlet weak var moveToYesterDay: UIButton!
    @IBOutlet weak var calendarOpenButton: UIButton!
    @IBOutlet weak var moveToTomorrow: UIButton!
    
    //MARK: - IBAction
    @IBAction func show(_ sender: Any) {
        showMoreFlag = true
        setCollectionViewSize(cellCount: winnerArray.count)
        winnerCollectionView.reloadData()
    }

    @IBAction func moveToYesterDay(_ sender: Any) {
        if Defaults[.isSignIn] == false {
            signUpAlert(viewController: self)
        } else {
            let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: dateFormatter.date(from: selectedDate)!)
            let yesterdayString = dateFormatter.string(from: yesterDay!)
            
            reloadOpenCalendarView(selectedDate: yesterdayString)
            if selectedDate == todayDate {
                if Date() < Time.sharedInstance.getAnounceStartTime() {
                    beforeAnounceView.isHidden = false
                } else {
                    initData()
                    beforeAnounceView.isHidden = true
                }
            } else {
                initData()
                beforeAnounceView.isHidden = true
            }
            //initData()
            winnerCollectionView.reloadData()
        }
    }
    
    @IBAction func calendarOpenButton(_ sender: Any) {
        if Defaults[.isSignIn] == false {
            signUpAlert(viewController: self)
        } else {
            calendarViewController?.delegate = self
            calendarViewController?.selectedDate = selectedDate
            calendarViewController?.modalPresentationStyle = .overCurrentContext
            present(calendarViewController!, animated: true, completion: nil)
        }
    }
    
    @IBAction func moveToTomorrow(_ sender: Any) {
        if Defaults[.isSignIn] == false {
            signUpAlert(viewController: self)
        } else {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: dateFormatter.date(from: selectedDate)!)
            let tomorrowString = dateFormatter.string(from: tomorrow!)
            reloadOpenCalendarView(selectedDate: tomorrowString)
            if selectedDate == todayDate {
                if Date() < Time.sharedInstance.getAnounceStartTime() {
                    //화면
                    beforeAnounceView.isHidden = false

                } else {
                    initData()
                    beforeAnounceView.isHidden = true
                }
            } else {
                initData()
                beforeAnounceView.isHidden = true
            }
            //initData()
            winnerCollectionView.reloadData()
        }
    }
    
    //MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        winnerCollectionView.isScrollEnabled = false
        dateFormatter.dateFormat = "yyyy.MM.dd"
        selectedDate = todayDate
        
        //make winner name array
        initData()
        reloadOpenCalendarView(selectedDate: todayDate)
        setCollectionViewSize(cellCount: 6)
        winnerCollectionView.layer.borderWidth = 1
        winnerCollectionView.layer.borderColor = UIColor.gray.cgColor

        //ui init
        if Date() < Time.sharedInstance.getAnounceStartTime() {
            beforeAnounceView.isHidden = false
        } else {
            beforeAnounceView.isHidden = true
        }
        setGiftImage()
        initCalendarFunction()
    
    }

    //MARK - UI Set Function
    func setCollectionViewSize(cellCount: Int) {
        if showMoreFlag {
            self.winnerCollectionViewHeight.constant = CGFloat((cellCount / 2) * 25 + 50)
        } else {
            self.winnerCollectionViewHeight.constant = CGFloat((cellCount / 2) * 25 + 100)
        }
    }

    func reloadOpenCalendarView(selectedDate: String) {
        self.selectedDate = selectedDate
        calendarOpenButton.setTitle(selectedDate, for: .normal)
        let dateSelectedDate = dateFormatter.date(from: selectedDate)
        
        if dateSelectedDate?.compare(Time.sharedInstance.getAppStartDate()) == ComparisonResult.orderedSame {
            moveToYesterDay.isHidden = true
        } else {
            moveToYesterDay.isHidden = false
        }
        
        // TODO: 날짜비교로 수정하기
        if selectedDate == todayDate { moveToTomorrow.isHidden = true }
        else { moveToTomorrow.isHidden = false }
    }
    
    func initCalendarFunction() {
        calendarViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController)
        selectedDate = todayDate
    }
    
    //MARK - Data Set Function
    func initData() {
        var winnerName = ""
        winnerArray.removeAll()
        print("winnerArray1>>\(winnerArray)")
        if let winner = uiRealm.objects(Prize.self).filter("prizeDate == '\(selectedDate!)'").last?.winner {
            for i in winner.characters {
                if i == " " {
                    winnerArray.append(winnerName)
                    winnerName = ""
                } else { winnerName.append(i) }
            }
        }
        winnerArray.append(winnerName)
        
        if winnerArray.count > 8 {
            sixTestInfo.removeAll()
            sixTestInfo.append(contentsOf: winnerArray[0..<6])
        } else {
            sixTestInfo = winnerArray
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
                            self.giftNameLabel.text = giftName
                        }
                        //png 처리
                        if let giftPng = n.giftPng {
                            let url = "http://onepercentserver.azurewebsites.net/OnePercentServer/resources/common/image/" + giftPng
                            self.giftImageView.af_setImage(withURL: NSURL(string: url) as! URL)
                        }
                    }
                }
        }
    }

    
}

//MARK: - Extension UICollectionViewDataSource
extension WinnerViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if showMoreFlag {
            return winnerArray.count
        } else {
            return sixTestInfo.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = winnerCollectionView.dequeueReusableCell(withReuseIdentifier: "winnerCollectionViewCell", for: indexPath) as! WinnerCollectionViewCell
        
        if showMoreFlag {
            cell.winnerIdLabel.text = winnerArray[indexPath.row]//test[indexPath.row]
            
        } else {
            cell.winnerIdLabel.text = sixTestInfo[indexPath.row]
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = winnerCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "winnerCollectionHeaderView", for: indexPath) as! WinnerCollectionHeaderView
            if winnerArray.count / 100 == 0 {
                headerView.winnerCountLabel.text = "(1명)"
            } else {
                headerView.winnerCountLabel.text = "(\(winnerArray.count / 100)명)"
            }
            return headerView
        case UICollectionElementKindSectionFooter:
            let footerView = winnerCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "winnerCollectionFooterView", for: indexPath) as! winnerCollectionFooterView
            if winnerArray.count < 8 {
                footerView.frame.size = CGSize(width: footerView.frame.width, height: 0)
            }
            return footerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

//MARK: - Extension CalendarViewControllerDelegate
extension WinnerViewController: CalendarViewControllerDelegate {
    func dateSelectDone(date: String) {
        reloadOpenCalendarView(selectedDate: date)
        // TODO: 오늘날짜 선택시 발표전이면 todayquestion에서 데이터 받기 그외 initData에서 받기
        if date == todayDate {
            if Date() < Time.sharedInstance.getAnounceStartTime() {
                //화면
                beforeAnounceView.isHidden = false
            } else {
                initData()
                beforeAnounceView.isHidden = true
            }
        } else {
            initData()
            beforeAnounceView.isHidden = true
        }
        //initData()
        winnerCollectionView.reloadData()
    }
}
