//
//  MoreViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 11. 7..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class MoreViewController: UIViewController {
    // MARK: - Property
    
    // MARK: - IBAction
    
    @IBAction func logOutButtonClick(_ sender: AnyObject) {
        Defaults[.isSignIn] = false
        Defaults[.id] = ""
    }
    // MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()

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
