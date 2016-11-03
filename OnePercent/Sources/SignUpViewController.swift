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

class SignUpViewController: UIViewController {
    
    // MARK: - Property
    let disposeBag = DisposeBag()

    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - IBAction    
    @IBAction func closeButtonClick(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }
    @IBAction func signUpButtonClick(_ sender: AnyObject) {
        User.sharedInstance.emptyId = idTextField.text!
        User.sharedInstance.emptyPassword = passwordTextField.text!
        self.dismiss(animated: true)
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
