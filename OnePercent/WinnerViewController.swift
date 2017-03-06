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

    var sixTestInfo: [String] = []
    var showMoreFlag: Bool = false
    let dateFormatter = DateFormatter()
    var selectedDate: String!

    var winnerArray:[String] = []
    var todayDate: String {
        return dateFormatter.string(from: Date())
    }
    
    
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var winnerCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var winnerCollectionView: UICollectionView!
    @IBOutlet weak var calendarNavigationView: CalendarNavigationView!
    
    @IBAction func show(_ sender: Any) {
        showMoreFlag = true
        setCollectionViewSize(cellCount: winnerArray.count)
        winnerCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        winnerCollectionView.isScrollEnabled = false
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        //calendarNavigation UI init
        let cnView = CalendarNavigationView.instanceFromNib()
         cnView.frame = CGRect(origin: calendarNavigationView.bounds.origin , size: CGSize(width: calendarNavigationView.frame.width, height: calendarNavigationView.frame.height))
        calendarNavigationView.addSubview(cnView)
        
        //make winner name array
        var winnerName = ""
        if let winner = uiRealm.objects(Prize.self).filter("prizeDate = '\(todayDate)'").last?.winner {
            for i in winner.characters {
                if i == " " {
                    winnerArray.append(winnerName)
                    winnerName = ""
                } else { winnerName.append(i) }
            }
        }
        winnerArray.append(winnerName)
    
        if winnerArray.count > 8 {
            sixTestInfo.append(contentsOf: winnerArray[0..<8])
        } else {
            sixTestInfo = winnerArray
        }
        
        setCollectionViewSize(cellCount: sixTestInfo.count)
        winnerCollectionView.layer.borderWidth = 1
        winnerCollectionView.layer.borderColor = UIColor.gray.cgColor
                // Do any additional setup after loading the view.
        getGiftImage()
        
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
    func setCollectionViewSize(cellCount: Int) {
        if showMoreFlag {
            self.winnerCollectionViewHeight.constant = CGFloat((cellCount / 2) * 25 + 50)

        } else {
            self.winnerCollectionViewHeight.constant = CGFloat((cellCount / 2) * 25 + 100)

        }
        
    }
}

extension WinnerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    
    func getGiftImage() {
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
    /*
     override func collectionView(_ collectionView: UICollectionView,
     viewForSupplementaryElementOfKind kind: String,
     at indexPath: IndexPath) -> UICollectionReusableView {
     //1
     switch kind {
     //2
     case UICollectionElementKindSectionHeader:
     //3
     let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
     withReuseIdentifier: "FlickrPhotoHeaderView",
     for: indexPath) as! FlickrPhotoHeaderView
     headerView.label.text = searches[(indexPath as NSIndexPath).section].searchTerm
     return headerView
     default:
     //4
     assert(false, "Unexpected element kind")
     }
     }
     */

}
