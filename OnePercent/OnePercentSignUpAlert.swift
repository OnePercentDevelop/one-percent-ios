//
//  OnePercentSignUpAlert.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 2. 28..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import Foundation
import UIKit

func signUpAlert(viewController: UIViewController) {
    let alertController = UIAlertController(title: "", message: "인증이 필요한 서비스입니다ㅎㅎ", preferredStyle: UIAlertControllerStyle.alert)
    
    alertController.addAction(UIAlertAction(title: "로그인", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        let vc = viewController.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        viewController.present(vc!, animated: true, completion: nil)
    })
    
    alertController.addAction(UIAlertAction(title: "회원가입", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        let vc = viewController.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        viewController.present(vc!, animated: true, completion: nil)
    })
    
    alertController.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
    })
    
    viewController.present(alertController, animated: true, completion: nil)
}
