//
//  TodayViewController.swift
//  widget
//
//  Created by 김혜원 on 2018. 10. 9..
//  Copyright © 2018년 김혜원. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var presentImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Question
        let shareDefaults = UserDefaults(suiteName: "group.onepercent.TodayExtensionSharingDefaults")
        let question = shareDefaults!.string(forKey: "question")
        questionLabel.text = question
        
        //Image
        let presentImageUrl = shareDefaults?.url(forKey: "presentImageUrl")
        if let url = presentImageUrl {
            DispatchQueue.global().async {
                if let data = try? Data( contentsOf:url) {
                    DispatchQueue.main.async {
                        self.presentImageView.image = UIImage(data: data)
                    }
                }
            }
        }

//        let presentImageUrl = shareDefaults!.string(forKey: "presentImageUrl")
//        let url = URL(string: presentImageUrl ?? "")
//        print("Hyewonurl: \(url)")
//        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//        presentImageView.image = UIImage(data: data!)
//
//
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
}
