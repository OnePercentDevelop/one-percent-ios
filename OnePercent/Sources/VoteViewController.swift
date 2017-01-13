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
import RealmSwift

class VoteViewController: UIViewController {

    // MARK: - calendar property
    var calendarViewController: CalendarViewController?
    
    // MARK: - Property
    @IBOutlet weak var voteCollectionView: UICollectionView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var voteEntryWinnerView: UIView!
    @IBOutlet weak var calendarOpenButton: UIButton!
    
    @IBOutlet weak var nowStateLabel: UILabel!
    @IBOutlet weak var voteSendButton: OnePercentButton!
    @IBAction func moveToYesterDay(_ sender: AnyObject) {
        
    }

    @IBAction func moveToTomorrow(_ sender: AnyObject) {
    }
    
    var selectedItem : Int? = nil
    var examples = [String]()
    let dateFormatter = DateFormatter()
    var todayDate: String!
    var nowstate: String!
    
    //realm property
    var notificationToken: NotificationToken!
//    var r ealm: Realm!

    
    // MARK: - IBAction
    @IBAction func calendarOpenButton(_ sender: AnyObject) {
        calendarViewController?.delegate = self
        calendarViewController?.modalPresentationStyle = .overCurrentContext
        present(calendarViewController!, animated: true, completion: nil)
    }
    
    @IBAction func voteSendButton(_ sender: AnyObject) {
        if selectedItem != nil {
            //request
            let parameters: Parameters = [
                "user_id" : Defaults[.id],
                "vote_date" : todayDate!,
                "vote_answer" : selectedItem! + 1
                ]
            
            Alamofire
                .request("http://onepercentserver.azurewebsites.net/OnePercentServer/insertVote.do", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .log(level: .verbose)
//                .responseObject { (response : DataResponse<>) in
//            }
            
            //realm
            
            let newVote = MyVote()
            newVote.myVoteDate = todayDate
            newVote.selectedNumber = selectedItem!
            
//            let realm = try! Realm()

            try! uiRealm.write {
                uiRealm.add(newVote)
            }
            
            
        } else {
            let alertController = UIAlertController(title: "", message: "보기를 선택해주세요ㅎㅎ", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
//        voteEntryWinnerView.isHidden = true
        initAlamofireFunction()
        
        dateFormatter.dateFormat = "yyyy년MM월dd일"
        todayDate = dateFormatter.string(from: Date())
        calendarOpenButton.setTitle("\(todayDate!)", for: .normal)

        initCalendarFunction()
        initViewFunction()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        voteCollectionView.allowsMultipleSelection = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - init Functions
    func initAlamofireFunction() {
        Alamofire
            .request("http://onepercentserver.azurewebsites.net/OnePercentServer/main.do", method: .get)
            .log(level: .verbose)
            .responseObject { (response: DataResponse<HomeInformationResponse>) in
                if let mainResult = response.result.value?.mainResult {
                    for n in mainResult {
                        if let question = n.question {
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
    
    func initCalendarFunction() {
        calendarViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController)
    }
    
    func initViewFunction() {
        nowstate = Time.sharedInstance.getNowStateText()
        if nowstate == "투표중" {
            voteSendButton.setTitle("투표중intext", for: .normal)
            voteSendButton.isHidden = false //투표전
            voteEntryWinnerView.isHidden = true
            voteCollectionView.allowsSelection = true
            //투표전
            nowStateLabel.isHidden = true
            //투표후
            // nowStateLabel.isHidden = false
            //nowStateLabel.text = "오늘의 투표에 이미 참여하셨습니다"
        } else if nowstate == "투표대기중" {
            voteSendButton.setTitle(nowstate, for: .normal)
            voteSendButton.isHidden = true
            voteEntryWinnerView.isHidden = true
            voteCollectionView.allowsSelection = false
            nowStateLabel.isHidden = false
            nowStateLabel.text = "투표시작을 기다려주세요"
        } else if nowstate == "결과 집계 중" {
            voteSendButton.isHidden = true
            voteEntryWinnerView.isHidden = true
            voteCollectionView.allowsSelection = false
            nowStateLabel.isHidden = false
            nowStateLabel.text = "투표결과 집계중입니다"
            
        } else if nowstate == "당첨자발표중" {
            voteSendButton.isHidden = true
            voteEntryWinnerView.isHidden = false
            voteCollectionView.allowsSelection = false
            nowStateLabel.isHidden = true
        }
    }
    
    //realm function
//    func setupRealm() {
//        // Log in existing user with username and password
//        let username = "test"  // <--- Update this
//        let password = "test"  // <--- Update this
//        
//        SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false), server: URL(string: "http://127.0.0.1:9080")!) { user, error in
//            guard let user = user else {
//                fatalError(String(describing: error))
//            }
//            
//            DispatchQueue.main.async {
//                // Open Realm
//                let configuration = Realm.Configuration(
//                    syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://127.0.0.1:9080/~/realmtasks")!)
//                )
//                self.realm = try! Realm(configuration: configuration)
//                
//                // Show initial tasks
//                func updateVote() {
//                    if self.items.realm == nil, let list = self.realm.objects(TaskList.self).first {
//                        self.items = list.items
//                    }
//                    self.tableView.reloadData()
//                }
//                updateList()
//                
//                // Notify us when Realm changes
//                self.notificationToken = self.realm.addNotificationBlock { _ in
//                    updateList()
//                }
//            }
//        }
//    }
    
    deinit {
        notificationToken.stop()
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
//        cell.voteResultView.isHidden = true

        if nowstate == "당첨자발표중" {
            cell.voteResultView.isHidden = false
            cell.chargeImageView.frame = CGRect(origin: cell.bounds.origin , size: CGSize(width: cell.frame.width * 0.5, height: cell.frame.height)) //CGSize(width: cell.frame.width * 0.5, height: cell.frame.height)
        } else {
            cell.voteResultView.isHidden = true
            cell.chargeImageView.frame = CGRect(origin: cell.bounds.origin , size: CGSize(width: cell.frame.width * 0, height: cell.frame.height))
        }

        
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
