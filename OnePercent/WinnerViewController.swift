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
import DeviceGuru

//todo: cell size, viewsize

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
    let minimumShowWinnerNumber = 4
    
    //MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var winnerCollectionView: UICollectionView!
    @IBOutlet weak var beforeAnounceView: UIView!
    @IBOutlet weak var moveToYesterDay: UIButton!
    @IBOutlet weak var calendarOpenButton: UIButton!
    @IBOutlet weak var moveToTomorrow: UIButton!
    
    //layout
    @IBOutlet weak var winnerCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noticeWinnerLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var prizeItemBackroundImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var giftImageViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - IBAction
    @IBAction func show(_ sender: Any) {
        showMoreFlag = true
        scrollView.isScrollEnabled = true
        setCollectionViewSize(cellCount: winnerArray.count)
        winnerCollectionView.reloadData()
    }

    @IBAction func moveToYesterDay(_ sender: Any) {
        if Defaults[.isSignIn] == false {
            signUpAlert(viewController: self)
            self.winnerCollectionView.reloadData()
        } else {
            if let selectedDate =  selectedDate {
                let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: dateFormatter.date(from: selectedDate)!)
                setSelectedDate(new: Time.sharedInstance.stringFromDateDotyyyyMMdd(date: yesterDay!))
                setCalendarNavigationView()
                setData()
            }
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
            setSelectedDate(new: Time.sharedInstance.stringFromDateDotyyyyMMdd(date: tomorrow!))
            setCalendarNavigationView()
            setData()
        }
    }
    
    //MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        setGiftImage()
        setLayout()
        
        //set collectionview option
        winnerCollectionView.isScrollEnabled = false
        winnerCollectionView.layer.borderWidth = 1
        winnerCollectionView.layer.borderColor = UIColor.lightGray.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        scrollView.isScrollEnabled = false
        setSelectedDate(new: todayDate)
        setData()
        setCalendarNavigationView()
        
        setCollectionViewSize(cellCount: sixTestInfo.count)
        initCalendarFunction()
    }
    
    //MARK - UI Set Function
    func setCollectionViewSize(cellCount: Int) {
        if showMoreFlag {
            if cellCount > minimumShowWinnerNumber {
                let cellHeight = (winnerCollectionView.frame.height - 100) / 5
                let height = CGFloat(cellCount) * (cellHeight + 10)
                self.winnerCollectionViewHeight.constant = height
            }
        } else {
//            switch DeviceGuru.hardware() {
//            case Hardware.iphone_5, Hardware.iphone_5C, Hardware.iphone_5S, Hardware.iphone_SE:
//                self.winnerCollectionViewHeight.constant = 170
//            case Hardware.iphone_6, Hardware.iphone_6S ,Hardware.iphone_7:
//                self.winnerCollectionViewHeight.constant = 225
//            case Hardware.iphone_6_PLUS, Hardware.iphone_6_PLUS, Hardware.iphone_7_PLUS: break
//            default:
//                self.winnerCollectionViewHeight.constant = 170
//            }
        }
    }
    
    func initCalendarFunction() {
        calendarViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController)
    }
    
    func setView() {
        
    }
    
    func setCalendarNavigationView() {
        calendarOpenButton.setTitle(selectedDate, for: .normal)
        
        if selectedDate == todayDate {
            moveToTomorrow.isHidden = true
        } else if selectedDate == Time.sharedInstance.getAppStartStringDate() {
            moveToYesterDay.isHidden = true
        } else {
            moveToTomorrow.isHidden = false
            moveToYesterDay.isHidden = false
        }
    }

    func setLayout() {
//        switch DeviceGuru.hardware() {
//        case Hardware.iphone_5, Hardware.iphone_5C, Hardware.iphone_5S, Hardware.iphone_SE: break
//        case Hardware.iphone_6, Hardware.iphone_6S ,Hardware.iphone_7:
//            self.winnerCollectionViewHeight.constant = 225
//            noticeWinnerLabelTopConstraint.constant = 20
//            prizeItemBackroundImageViewHeightConstraint.constant = 130
//            giftImageViewHeightConstraint.constant = 90
//        case Hardware.iphone_6_PLUS, Hardware.iphone_6_PLUS, Hardware.iphone_7_PLUS: break
//        default:
//            self.winnerCollectionViewHeight.constant = 170
//            noticeWinnerLabelTopConstraint.constant = 15
//            prizeItemBackroundImageViewHeightConstraint.constant = 100
//            giftImageViewHeightConstraint.constant = 60
//        }
    }
    
    //MARK - Data Set Function
    func setData() {
        showMoreFlag = false
        if selectedDate == todayDate {
            if Date() < Time.sharedInstance.getAnounceStartTime() {
                beforeAnounceView.isHidden = false
            } else {
                setWinnerArray()
                beforeAnounceView.isHidden = true
            }
        } else {
            setWinnerArray()
            beforeAnounceView.isHidden = true
        }
        setCollectionViewSize(cellCount: winnerArray.count)
        winnerCollectionView.reloadData()
    }
    
    func setWinnerArray() {
        var winnerName = ""
        winnerArray.removeAll()
        print("prizeDate == '\(selectedDate!)'")
        if let winner = uiRealm.objects(Prize.self).filter("prizeDate == '\(selectedDate!)'").last?.winner {
            for i in winner.characters {
                if i == " " {
                    winnerArray.append(winnerName)
                    winnerName = ""
                } else { winnerName.append(i) }
            }
        }
        winnerArray.append(winnerName)
        
        if winnerArray.count > minimumShowWinnerNumber {
            sixTestInfo.removeAll()
            sixTestInfo.append(contentsOf: winnerArray[0..<minimumShowWinnerNumber])
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
//                            self.giftImageView.af_setImage(withURL: NSURL(string: url) as! URL)
                        }
                    }
                }
        }
    }

    func setSelectedDate(new date: String) {
        selectedDate = date
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
        print("seletectDate:\(selectedDate)>>winnerArray:\(winnerArray)")
        cell.winnerIdLabel.text = winnerArray[indexPath.row]
        if winnerArray[indexPath.row] == Defaults[.id] {
            cell.winnerIdLabel.tintColor = UIColor.red
        } else {
            cell.winnerIdLabel.tintColor = UIColor.black
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = winnerCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "winnerCollectionHeaderView", for: indexPath) as! WinnerCollectionHeaderView
                headerView.winnerCountLabel.text = "(\(winnerArray.count) 명)"
            return headerView
        case UICollectionElementKindSectionFooter:
            let footerView = winnerCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "winnerCollectionFooterView", for: indexPath) as! winnerCollectionFooterView
            if winnerArray.count < minimumShowWinnerNumber {
                footerView.frame.size = CGSize(width: footerView.frame.width, height: 0)
            }
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

// MARK: - extension UICollectionViewDelegateFlowLayout
extension WinnerViewController: UICollectionViewDelegateFlowLayout {
//    private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellSize = CGSize(width: winnerCollectionView.frame.width, height: (winnerCollectionView.frame.height - 130) / CGFloat(minimumShowWinnerNumber))
//        return cellSize
//    }
}

//MARK: - Extension CalendarViewControllerDelegate
extension WinnerViewController: CalendarViewControllerDelegate {
    func dateSelectDone(date: String) {
        setSelectedDate(new: date)
        setCalendarNavigationView()
        setData()
//        setCollectionViewSize(cellCount: winnerArray.count)
    }
}
