//
//  MoreWithViewViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 3. 10..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import UIKit

class MoreWithViewViewController: UIViewController {
    //MARK: - Property
    var recentVersion: Double = 0
    var nowVersion: Double = 0
    
    //MARK: - IBOutlet
    @IBOutlet weak var moreTextView: UITextView!
    @IBOutlet weak var moreButton: OnePercentButton!
    @IBOutlet weak var versionView: UIView!
    @IBOutlet weak var nowVersionLabel: UILabel!
    @IBOutlet weak var recentVersionLabel: UILabel!
    @IBOutlet weak var fAandQLabel: UILabel!
    
    //MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let title = title else {
            return
        }
        switch title {
        case "버전정보":
            moreTextView.isHidden = true
            fAandQLabel.isHidden = true
            
            nowVersionLabel.text = "현재버전 : \(nowVersion)"
            recentVersionLabel.text = "최신버전 : \(recentVersion)"
            if nowVersion == recentVersion {
                moreButton.setTitle("현재 최신 버전입니다.", for: .normal)
                moreButton.buttonBackgroundColor = UIColor(red: 217, green: 217, blue: 217)
                moreButton.tintColor = UIColor.darkGray
                moreButton.isEnabled = false
            } else {
                moreButton.setTitle("최신 버전 업데이트", for: .normal)
                moreButton.buttonBackgroundColor = UIColor(red: 85, green: 160, blue: 214)
                moreButton.tintColor = UIColor.white
                moreButton.isEnabled = true
            }
        case "고객센터/문의하기":
            moreTextView.isHidden = true
            versionView.isHidden = true
            
            moreButton.setTitle("문의하기", for: .normal)
            moreButton.buttonBackgroundColor = UIColor(red: 85, green: 160, blue: 214)
            moreButton.tintColor = UIColor.white
            moreButton.isEnabled = true
        default: break
            
        }
    }
}
