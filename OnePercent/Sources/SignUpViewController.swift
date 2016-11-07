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
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    let uuid = UUID().uuidString
    var id: String? = nil
    var password: String? = nil
    
    
    // MARK: - IBAction
    @IBAction func closeButtonClick(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func signUpButtonClick(_ sender: AnyObject) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년MM월dd일"
        let todayDate = dateFormatter.string(from: Date())
        
        print("user: \(self.idTextField.text)")
        print("user: \(self.passwordTextField.text)")
        
        let parameters: Parameters = [
            "user_id" : self.idTextField.text!,
            "user_password" : self.passwordTextField.text!,
            "user_token" : uuid,
            "sign_date" : todayDate
        ]
        
        for i in parameters {
            print(i.value)
        }
        
        Alamofire.request("http://onepercentserver.azurewebsites.net/OnePercentServer/insertUser.do", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .log(level: .verbose)
            .responseObject { (response: DataResponse<SignUpResultResponse>) in
                if response.result.isSuccess {
                    if let state = response.result.value?.signUpResult?.first?.state {
                        print("state: \(state)")
                        if state == "success" {
                            Defaults[.isSignIn] = true
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        //self.present(vc!, animated: true, completion: nil)
        self.show(vc!, sender: self)
        
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
            $0!.utf8.count > 10 && $0?.rangeOfCharacter(from: NSCharacterSet.decimalDigits, options: NSString.CompareOptions(), range: nil) != nil && $0?.rangeOfCharacter(from: NSCharacterSet.letters) == nil
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
        
        print("uuid: \(uuid)")
        // Do any additional setup after loading the view.
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
    
}
