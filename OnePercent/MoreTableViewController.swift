//
//  MoreTableViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 3. 9..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class MoreTableViewController: UITableViewController {

    //MARK: - Property
    var textLabelArray: [String] = []
    
    //MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let title = title else {
            return
        }
        switch title {
        case "계정관리":
            let arr = ["나의정보","pw변경","마이페이지","회원탈퇴","로그아웃"]
            textLabelArray.append(contentsOf: arr)
        case "공지사항": break
        case "고객센터":
            let arr = ["Q&A(문의하기)","FAQ(도움말)","약관및정책","회사소개"]
            textLabelArray.append(contentsOf: arr)
        case "push": break
        case "고객센터/약관및정책":
            let arr = ["이용약관","개인정보처리방침","운영정책"]
            textLabelArray.append(contentsOf: arr)
        default: break
            
        }
    }

    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textLabelArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTableViewCell", for: indexPath) as! MoreTableViewCell
        cell.nameLabel.text = textLabelArray[indexPath.row]
        
        switch title! {
        case "계정관리":
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = Defaults[.id]
            } else {
                cell.detailTextLabel?.text = ">"
            }
        default:
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var viewController: UIViewController? = nil
        
        guard let labelText = tableView.cellForRow(at: indexPath)?.textLabel?.text else {
            return
        }
        
        switch labelText {
        case "Q&A(문의하기)":
            viewController = self.storyboard?.instantiateViewController(withIdentifier: "MoreWithViewViewController")
            viewController?.title = "고객센터/문의하기"
        case "약관및정책":
            viewController = self.storyboard?.instantiateViewController(withIdentifier: "MoreTableViewController")
            viewController?.title = "고객센터/약관및정책"
            print("약관및정책")
        
        case "로그아웃":
            Defaults[.isSignIn] = false
        default: break
        }
        
        if let viewController = viewController {
            self.navigationController?.pushViewController(viewController , animated: true)
            
        }
    }
}


