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

class LoginViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }
    
    let disposeBag = DisposeBag()

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
            ($0?.utf8.count)! >= 4 && ($0?.utf8.count)! <= 10 && $0?.rangeOfCharacter(from: NSCharacterSet.decimalDigits, options: NSString.CompareOptions(), range: nil) != nil && $0?.rangeOfCharacter(from: NSCharacterSet.letters) != nil
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
    
    func loginButtonClick() {
        //id = idTextField.text!
        //password = passwordTextField.text!
        //User.init(id: idTextField.text!, password: passwordTextField.text!)
        User.sharedInstance.emptyId = idTextField.text!
        User.sharedInstance.emptyPassword = passwordTextField.text!
        self.dismiss(animated: true)
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
