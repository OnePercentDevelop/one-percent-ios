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
        @IBOutlet weak var moveToYesterDay: UIButton!
    @IBOutlet weak var moveToTomorrow: UIButton!
    @IBOutlet weak var entryNumberLabel: UILabel!
    @IBOutlet weak var winnerNumberLabel: UILabel!
    
    
    var selectedItem : Int? = nil
    var examples = [String]()
    var counts = [Int]()
    let dateFormatter = DateFormatter()
    var todayDate: String!
    var nowstate: String!
    var selectedDate: String!
    var entryAmount: Int = 0
    
    // MARK: - IBAction
    @IBAction func moveToYesterDay(_ sender: AnyObject) {
        let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: dateFormatter.date(from: selectedDate)!)
        let yesterdayString = dateFormatter.string(from: yesterDay!)
        reloadOpenCalendarView(selectedDate: yesterdayString)
        initVoteViewFunction()
        initData()
        voteCollectionView.reloadData()

    }

    @IBAction func moveToTomorrow(_ sender: AnyObject) {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: dateFormatter.date(from: selectedDate)!)
        let tomorrowString = dateFormatter.string(from: tomorrow!)
        reloadOpenCalendarView(selectedDate: tomorrowString)
        initVoteViewFunction()
        initData()
        voteCollectionView.reloadData()
    }
    
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
            
            //확인
            initVoteViewFunction()
            voteCollectionView.reloadData()

            
            
        } else {
            let alertController = UIAlertController(title: "", message: "보기를 선택해주세요ㅎㅎ", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Recycle Function
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        initAlamofireFunction()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        todayDate = dateFormatter.string(from: Date())
        
        initCalendarFunction()
        reloadOpenCalendarView(selectedDate: todayDate)
        initVoteViewFunction()
        initData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        voteCollectionView.allowsMultipleSelection = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
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
    
    func initData() {
        // TODO: 날짜 선택
        print("initData>>\(selectedDate!)>>\(uiRealm.objects(Vote.self).filter("voteDate=='\(selectedDate!)'"))>>\(uiRealm.objects(Vote.self).filter("voteDate='\(selectedDate!)'").first)")
        print("initData01/19>>\("2017.01.19")>>\(uiRealm.objects(Vote.self).filter("voteDate == '2017.01.19'"))>>\(uiRealm.objects(Vote.self).filter("voteDate == '2017.01.19'").first)")

        print("initData01/19>>\("2017.01.19")>>\(uiRealm.objects(Vote.self).filter("voteDate == %@","2017.01.18"))>>\(uiRealm.objects(Vote.self).filter("voteDate == '2017.01.19'").first)")
        print("initData>>\(uiRealm.objects(Vote.self))")


        if let todayVoteInfo = uiRealm.objects(Vote.self).filter("voteDate='\(selectedDate!)'").first {//("voteDate='2017.01.21'").first {

            self.questionLabel.text = (todayVoteInfo.question)
            self.examples.insert(todayVoteInfo.ex4, at: 0)
            self.examples.insert(todayVoteInfo.ex3, at: 0)
            self.examples.insert(todayVoteInfo.ex2, at: 0)
            self.examples.insert(todayVoteInfo.ex1, at: 0)
          
            self.counts.insert(todayVoteInfo.count4, at: 0)
            self.counts.insert(todayVoteInfo.count3, at: 0)
            self.counts.insert(todayVoteInfo.count2, at: 0)
            self.counts.insert(todayVoteInfo.count1, at: 0)

            self.entryAmount = todayVoteInfo.entryAmount
            self.entryNumberLabel.text = String(entryAmount)

            self.winnerNumberLabel.text = "오늘의 1% 는" + String(todayVoteInfo.winnerAmount) + "명 입니다"
        } else {
            print("todayVoteInfoError>>")
        }
    }
    
    func initCalendarFunction() {
        calendarViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController)
        selectedDate = todayDate
    }
    
    func initVoteViewFunction() {
        nowstate = Time.sharedInstance.getNowStateText()
        
        if nowstate == "당첨자발표중" || dateFormatter.date(from: selectedDate) != dateFormatter.date(from: todayDate) {
            initVoteViewWithHiddenProperty(voteSendButton: true, voteEntryWinnerView: false, voteCollectionView: false, nowStateLabel: true, nowStateLabelTxt: "")
        } else if nowstate == "투표중" {
            voteSendButton.setTitle("투표하기", for: .normal)
                if uiRealm.objects(MyVote.self).count == 0 || uiRealm.objects(MyVote.self).last!.myVoteDate != todayDate! { //투표전
                    initVoteViewWithHiddenProperty(voteSendButton: false, voteEntryWinnerView: true, voteCollectionView: true, nowStateLabel: true, nowStateLabelTxt: "")
                } else { //투표후
                    initVoteViewWithHiddenProperty(voteSendButton: true, voteEntryWinnerView: true, voteCollectionView: false, nowStateLabel: false, nowStateLabelTxt: "오늘의 투표에 이미 참여하셨습니다")
                }
        } else if nowstate == "투표대기중" {
            initVoteViewWithHiddenProperty(voteSendButton: true, voteEntryWinnerView: true, voteCollectionView: false, nowStateLabel: false, nowStateLabelTxt: "투표시작을 기다려주세요")
            voteSendButton.setTitle(nowstate, for: .normal)
        } else if nowstate == "결과 집계 중" {
            initVoteViewWithHiddenProperty(voteSendButton: true, voteEntryWinnerView: true, voteCollectionView: false, nowStateLabel: false, nowStateLabelTxt: "집계중입니다")
        }
    }
    
    func initVoteViewWithHiddenProperty(voteSendButton: Bool, voteEntryWinnerView: Bool, voteCollectionView: Bool, nowStateLabel: Bool,nowStateLabelTxt: String) {
        self.voteSendButton.isHidden = voteSendButton
        self.voteEntryWinnerView.isHidden = voteEntryWinnerView
        self.voteCollectionView.allowsSelection = voteCollectionView
        self.nowStateLabel.isHidden = nowStateLabel
        self.nowStateLabel.text = nowStateLabelTxt
    }

    func reloadOpenCalendarView(selectedDate: String) {
        self.selectedDate = selectedDate
        calendarOpenButton.setTitle(selectedDate, for: .normal)
        let appStartDate = dateFormatter.date(from: "2016.12.17")
        let dateSelectedDate = dateFormatter.date(from: selectedDate)
        
        if dateSelectedDate?.compare(appStartDate!) == ComparisonResult.orderedSame {
            moveToYesterDay.isHidden = true
        } else {
            moveToYesterDay.isHidden = false
        }
        
        // TODO: 날짜비교로 수정하기
        if selectedDate == todayDate { moveToTomorrow.isHidden = true }
        else { moveToTomorrow.isHidden = false }
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
            cell.voteResultView.isHidden = false
            let count = counts[indexPath.row]
            let rate:CGFloat = CGFloat(count) / CGFloat(entryAmount)
            print("count>>\(count)>>\(indexPath.row)>>rate>>\(rate)")
            cell.countLabel.text = String(count)
            cell.chargeImageView.frame = CGRect(origin: cell.bounds.origin , size: CGSize(width: cell.frame.width * rate, height: cell.frame.height))
            
            initVoteViewWithHiddenProperty(voteSendButton: true, voteEntryWinnerView: false, voteCollectionView: false, nowStateLabel: true, nowStateLabelTxt: "")
        } else {
            cell.voteResultView.isHidden = true
            cell.chargeImageView.frame = CGRect(origin: cell.bounds.origin , size: CGSize(width: cell.frame.width * 0, height: cell.frame.height))
            initVoteViewFunction()
        }

        // TODO: 내가 선택한 것 표시
        let selectedDateVote = uiRealm.objects(MyVote.self).filter("myVoteDate='\(selectedDate)'")
        let selectedDateVoteNumber = selectedDateVote.first?.selectedNumber
        print("indexPath.row>>\(indexPath.row)>>selectedNumber>>\(selectedDateVoteNumber)>>realm>>\(selectedDateVote.count)")
        if indexPath.row == selectedDateVoteNumber {
            cell.mySelectPresentImageView.isHidden = false
            
        } else {
            cell.mySelectPresentImageView.isHidden = true
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
        initVoteViewFunction()
        initData()
        voteCollectionView.reloadData()
    }
}
