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
    @IBOutlet weak var winnerCollectionViewHeight: DeviceConstraints!
//    @IBOutlet weak var noticeWinnerLabelTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var prizeItemBackroundImageViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var giftImageViewHeightConstraint: NSLayoutConstraint!
    var cellSize: CGSize!
    let cellSpacing: CGFloat = 10
    let reuseableHeight: CGFloat = 60
    
    //MARK: - IBAction
    @IBAction func showAllWinners(_ sender: Any) {
        presenter.showAllWinnersDidClick()
    }

    @IBAction func moveToYesterDay(_ sender: Any) {
        presenter.moveToYesterDayDidClick()
    }
    
    @IBAction func calendarOpenButton(_ sender: Any) {
        presenter.calendarOpenButtonClick(winnerViewController: self)
    }
    
    @IBAction func moveToTomorrow(_ sender: Any) {
        presenter.moveToTomorrowDidClick()
    }
    
    //MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDependencies = AppDependencies()
        appDependencies.installWinnerViewControllerIntoWindow(winnerViewController: self)
        
        cellSize = CGSize(width: winnerCollectionView.frame.width, height: (winnerCollectionViewHeight.constant - (reuseableHeight + cellSpacing) * 2) / CGFloat(minimumPresentingCount) - cellSpacing)
        
        winnerCollectionView.layer.borderWidth = 1
        winnerCollectionView.layer.borderColor = UIColor.lightGray.cgColor
        presenter.viewDidLoad()
    }
    
    //MARK - Layout Set Function
//    func setWinnerViewLayout() {
//        switch DeviceGuru.hardware() {
//        case Hardware.iphone_5, Hardware.iphone_5C, Hardware.iphone_5S, Hardware.iphone_SE:
//            winnerCollectionViewHeight.constant = 170
//            noticeWinnerLabelTopConstraint.constant = 15
//            prizeItemBackroundImageViewHeightConstraint.constant = 100
//            giftImageViewHeightConstraint.constant = 60
//        case Hardware.iphone_6, Hardware.iphone_6S ,Hardware.iphone_7:
//            winnerCollectionViewHeight.constant = 225
//            noticeWinnerLabelTopConstraint.constant = 20
//            prizeItemBackroundImageViewHeightConstraint.constant = 130
//            giftImageViewHeightConstraint.constant = 90
//        case Hardware.iphone_6_PLUS, Hardware.iphone_6_PLUS, Hardware.iphone_7_PLUS:
//            break // TODO
//        default: //출시할때 없애기
//            winnerCollectionViewHeight.constant = 225
//            noticeWinnerLabelTopConstraint.constant = 20
//            prizeItemBackroundImageViewHeightConstraint.constant = 130
//            giftImageViewHeightConstraint.constant = 90
//        }
//    }
}

//MARK: - Extension UICollectionViewDataSource
extension WinnerViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.winnersCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = winnerCollectionView.dequeueReusableCell(withReuseIdentifier: winnerCollectionViewCellIdentifier, for: indexPath) as! WinnerCollectionViewCell
        presenter.bind(cell, at: indexPath.row)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = winnerCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "winnerCollectionHeaderView", for: indexPath) as! WinnerCollectionHeaderView
            headerView.winnerCountLabel.text = presenter.winnersCollectionHeaderText
            return headerView
        case UICollectionElementKindSectionFooter:
            let footerView = winnerCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "winnerCollectionFooterView", for: indexPath) as! winnerCollectionFooterView
            if presenter.isExtendedButtonHidden {
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
    
    var dateTitle: String? {
        get { return calendarOpenButton.title(for: .normal) }
        set { calendarOpenButton.setTitle(newValue, for: .normal) }
    }
    var isMoveToTomorrowButtonHidden: Bool {
        get { return moveToTomorrow.isHidden }
        set { moveToTomorrow.isHidden = newValue }
    }
    var isMoveToYesterdayButtonHidden: Bool {
        get { return moveToYesterDay.isHidden }
        set { moveToYesterDay.isHidden = newValue }
    }
    var isBeforeAnounceViewHidden: Bool {
        get { return beforeAnounceView.isHidden }
        set { beforeAnounceView.isHidden = newValue }
    }
    
    func reloadWinnersCollection() {
        winnerCollectionView.reloadData()
    }
    
    func setWinnersCollectionExtended(_ isExtended: Bool) {
        if isExtended {
            let cellCount = presenter.winnersCount
            let constant = (cellSize.height + cellSpacing) * CGFloat(cellCount) + reuseableHeight
            
            winnerCollectionViewHeight.iPhone5Constant = constant
            winnerCollectionViewHeight.iPhone6Constant = constant
            winnerCollectionViewHeight.iPhone6PlusConstant = constant
            winnerCollectionViewHeight.defaultConstant = constant
        } else {
            winnerCollectionViewHeight.iPhone5Constant = WinnerCollectionViewHeightEnum.size5.rawValue
            winnerCollectionViewHeight.iPhone6Constant = WinnerCollectionViewHeightEnum.size6.rawValue
            winnerCollectionViewHeight.iPhone6PlusConstant = WinnerCollectionViewHeightEnum.size6plus.rawValue
            winnerCollectionViewHeight.defaultConstant = WinnerCollectionViewHeightEnum.size6.rawValue
        }
    }
    
    func showGiftData(gift: Gift) {
        giftNameLabel.text = gift.giftName
        giftImageView.af_setImage(withURL: NSURL(string: gift.giftPng!)! as URL)
    }

}

enum WinnerCollectionViewHeightEnum: CGFloat {
    case size5 = 170
    case size6 = 200
    case size6plus = 260 //임의로 작성
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
