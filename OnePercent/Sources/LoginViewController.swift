//
//  LoginViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 10. 27..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire
import SwiftyUserDefaults

class LoginViewController: UIViewController {
    // MARK: - Property
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    let disposeBag = DisposeBag()

    
    // MARK: - IBAction
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }
    
    
    // MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        
        logInButton.addTarget(self, action: #selector(LoginViewController.loginButtonClick), for: .touchUpInside)
        
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
            ($0?.utf8.count)! >= 4 && ($0?.utf8.count)! <= 10 /*&& $0?.rangeOfCharacter(from: NSCharacterSet.decimalDigits, options: NSString.CompareOptions(), range: nil) != nil && $0?.rangeOfCharacter(from: NSCharacterSet.letters) != nil*/
        }
        
        let credentialsValid: Driver<Bool> = Driver.combineLatest(userIdValid, userPasswordValid) {
            $0 && $1
        }
        
        credentialsValid.drive(onNext: {
            self.logInButton.isEnabled = $0
            if $0 {
                self.logInButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
            } else {
                self.logInButton.setTitleColor(UIColor.red, for: UIControlState.normal)
            }

        })
        .addDisposableTo(disposeBag)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Personal function
    func loginButtonClick() {
        //id = idTextField.text!
        //password = passwordTextField.text!
        //User.init(id: idTextField.text!, password: passwordTextField.text!)
        let parameters: Parameters = [
            "user_id" : self.idTextField.text!,
            "user_password" : self.passwordTextField.text!,
        ]
        for i in parameters {
            print("parameters: \(i.value)")
        }
        Alamofire.request("http://onepercentserver.azurewebsites.net/OnePercentServer/login.do?user_id=\(self.idTextField.text!)&user_password=\(self.passwordTextField.text!)" )
            .responseObject { (response: DataResponse<LoginResultResponse>) in
                if response.result.isSuccess {
                    if let state = response.result.value?.loginResult?.first?.state {
                        print("state: \(state)")
                        if state == "success" {
                            Defaults[.isSignIn] = true
                            Defaults[.id] = self.idTextField.text!
                            self.parent?.dismiss(animated: true)
                            self.dismiss(animated: true)
                        } else {
                            let alertController = UIAlertController(title: "", message: "아이디혹은 비밀번호가 잘못되었습니다.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
        }
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
