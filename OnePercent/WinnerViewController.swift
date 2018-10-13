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
import Firebase
import FirebaseStorage
import FirebaseUI

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
        return Time.sharedInstance.stringFromDateNoneyyyyMMdd(date: Date())
    }
    let minimumShowWinnerNumber = 6
    
    var ref: DatabaseReference!
    
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
//        if Defaults[.isSignIn] == false {
//            signUpAlert(viewController: self)
//            self.winnerCollectionView.reloadData()
//        } else {
            if let selectedDate =  selectedDate {
                let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: dateFormatter.date(from: selectedDate)!)
//                setSelectedDate(new: Time.sharedInstance.stringFromDateDotyyyyMMdd(date: yesterDay!))
                setSelectedDate(new: Time.sharedInstance.stringFromDateNoneyyyyMMdd(date: yesterDay!))
                setCalendarNavigationView()
                setData()
            }
//        }
    }
    
    @IBAction func calendarOpenButton(_ sender: Any) {
//        if Defaults[.isSignIn] == false {
//            signUpAlert(viewController: self)
//        } else {
            calendarViewController?.delegate = self
            calendarViewController?.selectedDate = selectedDate
            calendarViewController?.modalPresentationStyle = .overCurrentContext
            present(calendarViewController!, animated: true, completion: nil)
//        }
    }
    
    @IBAction func moveToTomorrow(_ sender: Any) {
//        if Defaults[.isSignIn] == false {
//            signUpAlert(viewController: self)
//        } else {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: dateFormatter.date(from: selectedDate)!)
//            setSelectedDate(new: Time.sharedInstance.stringFromDateDotyyyyMMdd(date: tomorrow!))
        setSelectedDate(new: Time.sharedInstance.stringFromDateNoneyyyyMMdd(date: tomorrow!))
            setCalendarNavigationView()
            setData()
//        }
    }
    
    //MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        
        dateFormatter.dateFormat = "yyyyMMdd"
        setSelectedDate(new: todayDate)

        setGiftImage()
        setData()
//        setLayout()
        
        //set collectionview option
        winnerCollectionView.isScrollEnabled = false
        winnerCollectionView.layer.borderWidth = 1
        winnerCollectionView.layer.borderColor = UIColor.lightGray.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        scrollView.isScrollEnabled = false
//        setData()
        setCalendarNavigationView()
        
//        setCollectionViewSize(cellCount: sixTestInfo.count)
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
        
        // TODO : 동기, 비동기
        self.ref.child("prizewinner").observeSingleEvent(of: .value, with: {snapshot in
            let snapshotValue = snapshot.value as! NSDictionary
            let winners = snapshotValue["\(self.selectedDate!)"]as? String ?? ""
            print("hyewonWinners: \(winners)")
            for i in winners.characters {
                if i == " " {
                    self.winnerArray.append(winnerName)
                    print("hyewonWinnerName: \(winnerName)")
                    winnerName = ""
                } else { winnerName.append(i) }
            }
            self.winnerArray.append(winnerName)
            
            if self.winnerArray.count > self.minimumShowWinnerNumber {
                self.sixTestInfo.removeAll()
                self.sixTestInfo.append(contentsOf: self.winnerArray[0..<self.minimumShowWinnerNumber])
            } else {
                self.sixTestInfo = self.winnerArray
                print("hyewonSixTestInfo: \(self.sixTestInfo) winnerArray: \(self.winnerArray)")
            }
            self.winnerCollectionView.reloadData()

        })
        
    }
    
    func setGiftImage() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let starsRef = storageRef.child("images/\(selectedDate!).jpg")
        let placeholderImage = UIImage(named: "information")
        self.giftImageView.sd_setImage(with: starsRef, placeholderImage: placeholderImage)
        
        self.ref.child("present/\(selectedDate!)").observeSingleEvent(of: .value, with: {snapshot in
            let snapshotValue = snapshot.value as! NSDictionary
            self.giftNameLabel.text = snapshotValue["name"]as? String ?? ""
        })
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
            print("hyewonCount: \(sixTestInfo.count)")
//            return sixTestInfo.count
            return winnerArray.count
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
