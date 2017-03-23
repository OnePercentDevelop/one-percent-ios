//
//  SignUpViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 10. 31..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Async
import Alamofire
import AlamofireObjectMapper
import SwiftyUserDefaults

class SignUpViewController: UIViewController {
    // MARK: - Property
    let disposeBag = DisposeBag()
    let uuid = UUID().uuidString
    var id: String? = nil
    var password: String? = nil
    
    //MARK: - IBOutlet
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
 
    // MARK: - IBAction
    @IBAction func closeButtonClick(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }
    
    @IBAction func signUpButtonClick(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let todayDate = dateFormatter.string(from: Date())

        let parameters: Parameters = [
            "user_id" : self.idTextField.text!,
            "user_password" : self.passwordTextField.text!,
            "user_token" : uuid,
            "sign_date" : todayDate,
       ]
        let url = "http://onepercentserver.azurewebsites.net/OnePercentServer/insertUser.do"
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .log(level: .verbose)
            .responseObject { (response: DataResponse<SignUpResultResponse>) in
                if response.result.isSuccess {
                    if let state = response.result.value?.signUpResult?.first?.state {
                        print("state: \(state)")
                        if state == "success" {
                            Defaults[.isSignIn] = true
                            Defaults[.id] = self.idTextField.text!
                            self.dismiss(animated: true)
                            
                        } else {
                            let alertController = UIAlertController(title: "", message: "회원가입 실패.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    
                }
            }
    }
    
    @IBAction func moveToLoginViewButtonClick(_ sender: AnyObject) {
        _ = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        
        idTextField.rx.text
            .observeOn(MainScheduler.instance)
            .subscribe { s in
                print(s)
            }
            .addDisposableTo(disposeBag)
        
        let userIdValid = idTextField.rx.text.asDriver().map {
            $0!.utf8.count > 9 && $0?.rangeOfCharacter(from: NSCharacterSet.decimalDigits, options: NSString.CompareOptions(), range: nil) != nil && $0?.rangeOfCharacter(from: NSCharacterSet.letters) == nil
        }
        
        let userPasswordValid = passwordTextField.rx.text.asDriver().map {
            ($0?.utf8.count)! >= 4 && ($0?.utf8.count)! <= 10 && $0?.rangeOfCharacter(from: NSCharacterSet.decimalDigits, options: NSString.CompareOptions(), range: nil) != nil && $0?.rangeOfCharacter(from: NSCharacterSet.letters) != nil
        }
        
        let credentialsValid: Driver<Bool> = Driver.combineLatest(userIdValid, userPasswordValid) {
            $0 && $1
        }
        
        credentialsValid.drive(onNext: {
            self.signUpButton.isEnabled = $0
            if $0 {
                self.signUpButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
            } else {
                self.signUpButton.setTitleColor(UIColor.red, for: UIControlState.normal)
            }
            
        })
            .addDisposableTo(disposeBag)
    }
}
