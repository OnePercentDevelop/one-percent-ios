//
//  TodayViewController.swift
//  widget
//
//  Created by 김혜원 on 2018. 10. 9..
//  Copyright © 2018년 김혜원. All rights reserved.
//

import UIKit
import NotificationCenter
import Firebase
//import FirebaseStorage
//import FirebaseUI

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var presentImageView: UIImageView!
    

    let dateFormatter = DateFormatter()
    var todayDate: String {
        return dateFormatter.string(from: Date())
    }
    var selectedDate: String {
        return todayDate
    }

    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyyMMdd"
//
        self.ref = Database.database().reference()

        setQuestion()
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
    
    func setDate() {
//        if now < Time.sharedInstance.getVoteStartTime() {
        
//        }
    }
    
    func setQuestion() {
        self.ref.child("today_question/\(selectedDate)").observeSingleEvent(of: .value, with: {snapshot in
            let snapshotValue = snapshot.value as! NSDictionary
            self.questionLabel.text = snapshotValue["question"]as? String ?? ""
        })
    }
    
    func setPresentImage() {
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        let reference = storageRef.child("images/\(selectedDate).jpg")
//        let placeholderImage = UIImage(named: "information")
//        self.presentImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
    
}
