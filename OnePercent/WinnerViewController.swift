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

let winnerCollectionViewCellIdentifier = "winnerCollectionViewCell"
let minimumPresentingCount: Int = 4

class WinnerViewController: UIViewController {
    var presenter: WinnerFromViewToPresenterProtocol!

    var winners: [String] = []
    var todayDate: String {
        return Time.sharedInstance.stringFromDateDotyyyyMMdd(date: Date())
    }
    var presentWinnersCount: Int!

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
    var cellSize: CGSize!
    let cellSpacing: CGFloat = 10
    let reuseableHeight: CGFloat = 60
    
    //MARK: - IBAction
    @IBAction func showAllWinners(_ sender: Any) {
        self.presenter.showAllWinnersDidClick(winnersCount: winners.count)
    }

    @IBAction func moveToYesterDay(_ sender: Any) {
        self.presenter.moveToYesterDayDidClick()
    }
    
    @IBAction func calendarOpenButton(_ sender: Any) {
        self.presenter.calendarOpenButtonClick(winnerViewController: self)
    }
    
    @IBAction func moveToTomorrow(_ sender: Any) {
        self.presenter.moveToTomorrowDidClick()
    }
    
    //MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDependencies = AppDependencies()
        appDependencies.installWinnerViewControllerIntoWindow(winnerViewController: self)
        setWinnerViewLayout()
        winnerCollectionView.layer.borderWidth = 1
        winnerCollectionView.layer.borderColor = UIColor.lightGray.cgColor
        self.presenter.viewDidLoad()
    }
    
    //MARK - Layout Set Function
    func setWinnerViewLayout() {
        switch DeviceGuru.hardware() {
        case Hardware.iphone_5, Hardware.iphone_5C, Hardware.iphone_5S, Hardware.iphone_SE:
            self.winnerCollectionViewHeight.constant = 170
            noticeWinnerLabelTopConstraint.constant = 15
            prizeItemBackroundImageViewHeightConstraint.constant = 100
            giftImageViewHeightConstraint.constant = 60
        case Hardware.iphone_6, Hardware.iphone_6S ,Hardware.iphone_7:
            self.winnerCollectionViewHeight.constant = 225
            noticeWinnerLabelTopConstraint.constant = 20
            prizeItemBackroundImageViewHeightConstraint.constant = 130
            giftImageViewHeightConstraint.constant = 90
        case Hardware.iphone_6_PLUS, Hardware.iphone_6_PLUS, Hardware.iphone_7_PLUS: break
        default: //출시할때 없애기
            self.winnerCollectionViewHeight.constant = 225
            noticeWinnerLabelTopConstraint.constant = 20
            prizeItemBackroundImageViewHeightConstraint.constant = 130
            giftImageViewHeightConstraint.constant = 90
        }
        cellSize = CGSize(width: winnerCollectionView.frame.width, height: (winnerCollectionViewHeight.constant - (reuseableHeight + cellSpacing) * 2) / CGFloat(minimumPresentingCount) - cellSpacing)
    }
}

//MARK: - Extension UICollectionViewDataSource
extension WinnerViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentWinnersCount!
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = winnerCollectionView.dequeueReusableCell(withReuseIdentifier: winnerCollectionViewCellIdentifier, for: indexPath) as! WinnerCollectionViewCell
        cell.winnerIdLabel.text = winners[indexPath.row]
        if winners[indexPath.row] == Defaults[.id] {
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
            headerView.winnerCountLabel.text = "(\(winners.count) 명)"
            return headerView
        case UICollectionElementKindSectionFooter:
            let footerView = winnerCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "winnerCollectionFooterView", for: indexPath) as! winnerCollectionFooterView
            if winners.count < minimumPresentingCount || presentWinnersCount > minimumPresentingCount {
                footerView.frame.size = CGSize(width: footerView.frame.width, height: 0)
            }
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

// MARK: - WinenrViewInterfaceProtocol
extension WinnerViewController: WinenrViewInterfaceProtocol {
    func showWinnerData(winners: [String]) {
        self.winners = winners
        winnerCollectionView.reloadData()
    }

    func showGiftData(gift: Gift) {
        self.giftNameLabel.text = gift.giftName
        self.giftImageView.af_setImage(withURL: NSURL(string: gift.giftPng!)! as URL)
    }

    //TODO: if 없애기 - present로?
    func setCalendarNavigationUI(selectedDate date: String) {
        calendarOpenButton.setTitle(date, for: .normal)
        if date == todayDate {
            moveToTomorrow.isHidden = true
        } else if date == Time.sharedInstance.getAppStartStringDate() {
            moveToYesterDay.isHidden = true
        } else {
            moveToTomorrow.isHidden = false
            moveToYesterDay.isHidden = false
        }
    }

    func setWinnerViewUI(selectedDate: String) {
        if selectedDate == todayDate {
            if Date() < Time.sharedInstance.getAnounceStartTime() {
                beforeAnounceView.isHidden = false
            } else {
                beforeAnounceView.isHidden = true
            }
        } else {
            beforeAnounceView.isHidden = true
        }
    }
    
    func setWinnerCollectionViewUI(cellCount: Int) {
        if cellCount <= minimumPresentingCount {
            switch DeviceGuru.hardware() {
            case Hardware.iphone_5, Hardware.iphone_5C, Hardware.iphone_5S, Hardware.iphone_SE:
                self.winnerCollectionViewHeight.constant = CGFloat(WinnerCollectionViewHeightEnum.size5.rawValue)
            case Hardware.iphone_6, Hardware.iphone_6S ,Hardware.iphone_7:
                self.winnerCollectionViewHeight.constant = CGFloat(WinnerCollectionViewHeightEnum.size6.rawValue)
            case Hardware.iphone_6_PLUS, Hardware.iphone_6_PLUS, Hardware.iphone_7_PLUS:
                self.winnerCollectionViewHeight.constant = CGFloat(WinnerCollectionViewHeightEnum.size6plus.rawValue)
            default:
                self.winnerCollectionViewHeight.constant = 170
            }
        } else {
            self.winnerCollectionViewHeight.constant = (cellSize.height + cellSpacing) * CGFloat(cellCount) + reuseableHeight
        }
        winnerCollectionView.reloadData()
    }
    
    func setPresentWinnersCount(cellCount: Int) {
        self.presentWinnersCount = cellCount
    }
}

enum WinnerCollectionViewHeightEnum: Int {
    case size5 = 170
    case size6 = 225
    case size6plus = 300 //임의로 작성
}

// MARK: - extension UICollectionViewDelegateFlowLayout
extension WinnerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

//MARK: - Extension CalendarViewControllerDelegate
extension WinnerViewController: CalendarViewControllerDelegate {
    func dateSelectDone(date: String) {
        self.presenter.calendarVCDelegateDateSelectDoneClick(date: date)
    }
}
