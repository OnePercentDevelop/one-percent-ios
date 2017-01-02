//
//  VoteViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 10. 28..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyUserDefaults
import CVCalendar

class VoteViewController: UIViewController {

    // MARK: - calendar property
    var calendarViewController: CalendarViewController?
    
    // MARK: - Property
    @IBOutlet weak var voteCollectionView: UICollectionView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var voteEntryWinnerView: UIView!
    @IBOutlet weak var calendarOpenButton: UIButton!
    
    @IBAction func moveToYesterDay(_ sender: AnyObject) {
        
    }

    @IBAction func moveToTomorrow(_ sender: AnyObject) {
    }
    
    var selectedItem : Int? = nil
    var examples = [String]()
    let dateFormatter = DateFormatter()
    var todayDate: String!
    
    // MARK: - IBAction
    @IBAction func calendarOpenButton(_ sender: AnyObject) {
        //calendarSelectView.isHidden = false
        //delegation init
//        self.calendarViewController.delegate = VoteViewController()

//        let calendarViewController = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        
        calendarViewController?.delegate = self
        calendarViewController?.modalPresentationStyle = .overCurrentContext
        present(calendarViewController!, animated: true, completion: nil)
    }
    
    @IBAction func voteSendButton(_ sender: AnyObject) {
        if selectedItem != nil {
            let parameters: Parameters = [
                "user_id" : Defaults[.id],
                "vote_date" : todayDate!,
                "vote_answer" : selectedItem! + 1 ,
                ]
            
            Alamofire
                .request("http://onepercentserver.azurewebsites.net/OnePercentServer/insertVote.do", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .log(level: .verbose)
//                .responseObject { (response : DataResponse<>) in
//            }
            
        } else {
            let alertController = UIAlertController(title: "", message: "보기를 선택해주세요ㅎㅎ", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        voteEntryWinnerView.isHidden = true
        initAlamofireFunction()
        
        dateFormatter.dateFormat = "yyyy년MM월dd일"
        todayDate = dateFormatter.string(from: Date())
        calendarOpenButton.setTitle("\(todayDate!)", for: .normal)
        
        // Do any additional setup after loading the view.
        
        //calendar init
        calendarViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController)
    }

        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        voteCollectionView.allowsMultipleSelection = false
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
    
    // MARK: - Alamofire init
    func initAlamofireFunction() {
        Alamofire
            .request("http://onepercentserver.azurewebsites.net/OnePercentServer/main.do", method: .get)
            .log(level: .verbose)
            .responseObject { (response: DataResponse<HomeInformationResponse>) in
                print(" : \(response.result.isSuccess)")
                if let mainResult = response.result.value?.mainResult {
                    for n in mainResult {
                        if let question = n.question {
                            print("ryan : \(question)")
                            self.questionLabel.text = question
                        }
                        
                        for i in n.example! {
                            if let q = i.firstQuestion {
                                self.examples.append(q)
                            }
                            if let q = i.secondQuestion {
                                self.examples.append(q)
                            }
                            
                            if let q = i.fourthQuestion {
                                self.examples.append(q)
                            }
                            
                            if let q = i.firstQuestion {
                                self.examples.append(q)
                            }
                        }
                    }
                    self.voteCollectionView.reloadData()
                }
        }
    }

}

// MARK: - public function

// MARK: - extension VoteViewController
extension VoteViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return examples.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = voteCollectionView.dequeueReusableCell(withReuseIdentifier: "voteCollectionViewCell", for: indexPath) as! VoteCollectionViewCell
        cell.questionLabel.text = examples[indexPath.row]
        cell.voteResultView.isHidden = true
        
        return cell
    }
}

extension VoteViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = voteCollectionView.cellForItem(at: indexPath)
        
        cell?.backgroundColor = UIColor(red: 85, green: 160, blue: 214)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("Defaults[.isSignIn]: \(Defaults[.isSignIn])")
        if Defaults[.isSignIn] == false {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
            self.present(vc!, animated: true, completion: nil)
        }
        
        let cell = voteCollectionView.cellForItem(at: indexPath)
        
        selectedItem = indexPath.row
        cell?.backgroundColor = UIColor(red: 85, green: 160, blue: 214)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = voteCollectionView.cellForItem(at: indexPath)
        
        cell?.backgroundColor = UIColor(red: 217, green: 217, blue: 217)
    }
}

extension VoteViewController: CalendarViewControllerDelegate {
    func dateSelectDone(date: String) {
        print("Vote date: \(date)")
        calendarOpenButton.setTitle(date, for: .normal)
    }
    
//    public func dateBeforeDate(_ date: Foundation.Date) -> Foundation.Date {
//        let calendar = calendarViewController?.calendarView.delegate?.calendar?() ?? Calendar.current
//        var components = Manager.componentsForDate(date, calendar: calendar)
//        
//        components.month! -= 1
//        let dateBefore = calendar.date(from: components)!
//        
//        return dateBefore
//    }
}
