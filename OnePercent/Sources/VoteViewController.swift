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
        let dateSelectedDate = dateFormatter.date(from: selectedDate)
        let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: dateSelectedDate!)
        let yesterdayString = dateFormatter.string(from: tomorrow!)

        reloadOpenCalendarView(selectedDate: yesterdayString)
    }
    @IBOutlet weak var moveToYesterDay: UIButton!
    @IBOutlet weak var moveToTomorrow: UIButton!

    @IBAction func moveToTomorrow(_ sender: AnyObject) {
        let dateSelectedDate = dateFormatter.date(from: selectedDate)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: dateSelectedDate!)
        let tomorrowString = dateFormatter.string(from: tomorrow!)

        reloadOpenCalendarView(selectedDate: tomorrowString)
    }
    
    func reloadOpenCalendarView(selectedDate: String) {
        self.selectedDate = selectedDate
        calendarOpenButton.setTitle(selectedDate, for: .normal)
        let appStartDate = dateFormatter.date(from: "2016년12월17일")
        let dateSelectedDate = dateFormatter.date(from: selectedDate)


        if dateSelectedDate?.compare(appStartDate!) == ComparisonResult.orderedSame {
            moveToYesterDay.isHidden = true
        } else {
            moveToYesterDay.isHidden = false
        }
        
        // TODO: 날짜비교로 수정하기
        if selectedDate == todayDate {
            moveToTomorrow.isHidden = true
        } else {
            moveToTomorrow.isHidden = false
        }
        
        
    }
    
    var selectedItem : Int? = nil
    var examples = [String]()
    let dateFormatter = DateFormatter()
    var todayDate: String!
    var nowstate: String!
    var selectedDate: String!
    
    // MARK: - IBAction
    @IBAction func calendarOpenButton(_ sender: AnyObject) {
        calendarViewController?.delegate = self
        calendarViewController?.selectedDate = selectedDate
        calendarViewController?.modalPresentationStyle = .overCurrentContext
        present(calendarViewController!, animated: true, completion: nil)
    }
    
    @IBAction func voteSendButton(_ sender: AnyObject) {
        if selectedItem != nil { //투표
            //request
            let parameters: Parameters = [
                "user_id" : Defaults[.id],
                "vote_date" : todayDate!,
                "vote_answer" : selectedItem!
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

        
        initCalendarFunction()
        
        //func call
        reloadOpenCalendarView(selectedDate: todayDate)

        
        initVoteViewFunction()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        voteCollectionView.allowsMultipleSelection = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("Votedisappear>>")
    }
    
    
    // MARK: - init Functions
    func initAlamofireFunction() {
        Alamofire
            .request("http://onepercentserver.azurewebsites.net/OnePercentServer/main.do", method: .get)
            .log(level: .verbose)
            .responseObject { (response: DataResponse<HomeInformationResponse>) in
                if let mainResult = response.result.value?.mainResult {
                    for result in mainResult {
                        if let question = result.question {
                            self.questionLabel.text = question
                        }
                        
                        for example in result.example! {
                            if let q = example.firstQuestion {
                                self.examples.append(q)
                            }
                            if let q = example.secondQuestion {
                                self.examples.append(q)
                            }
                            if let q = example.thirdQuestion {
                                self.examples.append(q)
                            }
                            if let q = example.fourthQuestion {
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
        
        selectedDate = todayDate
    }
    
    func initVoteViewFunction() {
        nowstate = Time.sharedInstance.getNowStateText()
        if nowstate == "투표중" {
            voteSendButton.setTitle("투표하기", for: .normal)
            voteEntryWinnerView.isHidden = true
            
            if uiRealm.objects(MyVote).count != 0 { //첫투표 x
                if uiRealm.objects(MyVote).last!.myVoteDate != todayDate! {
                    //투표전
                    voteSendButton.isHidden = false
                    nowStateLabel.isHidden = true
                    voteCollectionView.allowsSelection = true
                } else {
                    //투표후
                    voteSendButton.isHidden = true
                    nowStateLabel.isHidden = false
                    nowStateLabel.text = "오늘의 투표에 이미 참여하셨습니다"
                    voteCollectionView.allowsSelection = false
                }
            } else { //첫투표
                voteSendButton.isHidden = false
                nowStateLabel.isHidden = true
                voteCollectionView.allowsSelection = true
            }
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
    
    func initAnounceResultUIFunction() {
        voteSendButton.isHidden = true
        voteEntryWinnerView.isHidden = false
        voteCollectionView.allowsSelection = false
        nowStateLabel.isHidden = true
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
        
        if nowstate == "당첨자발표중" || dateFormatter.date(from: selectedDate) != dateFormatter.date(from: todayDate) {
            print("당첨자발표중 || \(dateFormatter.date(from: selectedDate)) != \(dateFormatter.date(from: todayDate))")
            cell.voteResultView.isHidden = false
            cell.chargeImageView.frame = CGRect(origin: cell.bounds.origin , size: CGSize(width: cell.frame.width * 0.5, height: cell.frame.height)) //CGSize(width: cell.frame.width * 0.5, height: cell.frame.height)
            initAnounceResultUIFunction()
        } else {
            cell.voteResultView.isHidden = true
            cell.chargeImageView.frame = CGRect(origin: cell.bounds.origin , size: CGSize(width: cell.frame.width * 0, height: cell.frame.height))
            initVoteViewFunction()
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
        reloadOpenCalendarView(selectedDate: date)
        voteCollectionView.reloadData()
    }
}
