//
//  MoreList.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 3. 13..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation

enum MoreList {
    case account, notice, customerCenter, pushNotice, versionInformation
//    case notice
//    case customerCenter
//    case pushNotice
//    case versionInformation

}

let accountList = ["나의정보","pw변경","마이페이지","회원탈퇴","로그아웃"]
let customerCenterList = ["약관목록","문의하기","FAQ"]
let userAgreement = ["이용약관","개인정보처리방침","운영정책"]

let MoreListDiction: [String:String] = ["계정관리":"accountList","고객정보":"customerCenterList","약관":"userAgreement"]


