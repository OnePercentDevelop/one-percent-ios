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
    // TODO: 회원인증 cancle누르면 deselect 되게
    // MARK: - Calendar Property
    var calendarViewController: CalendarViewController?
    
    // MARK: - Property
    var selectedItem: Int? = nil
    var examples = Array.init(repeating: "", count: 4)
    var counts = Array.init(repeating: 0, count: 4)
    var todayDate: String {
        return dateFormatter.string(from: Date())
    }
    var nowstate: String!
    var selectedDate: String!
    var entryAmount: Int = 0
    var maxVotedIndex: Int?
    var timer: Timer?
    let dateFormatter = DateFormatter()
    
    // MARK: - IBOutlet
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
    @IBOutlet weak var timeInformationLabel: UILabel!
    @IBOutlet weak var nowStateStackView: UIStackView!
    
    // MARK: - IBAction
    @IBAction func moveToYesterDay(_ sender: AnyObject) {
        if Defaults[.isSignIn] == false {
            signUpAlert(viewController: self)
            self.voteCollectionView.deselectAllItems(animated: false)
            self.voteCollectionView.reloadData()
        } else {
            if let selectedDate = selectedDate {
                let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: dateFormatter.date(from: selectedDate)!)
                setSelectedDate(new: Time.sharedInstance.stringFromDateDotyyyyMMdd(date: yesterDay!))
                setCalendarNavigationView()
                //reloadOpenCalendarView(selectedDate: Time.sharedInstance.stringFromDateDotyyyyMMdd(date: yesterDay!))
            }
            
            /*if selectedDate == todayDate {
                if Date() < Time.sharedInstance.getAnounceStartTime() {
                    setTodayQuestion()
                } else {
                    setSelectedDatedData()
                }
            } else {
                setSelectedDatedData()
            }
            voteCollectionView.reloadData()*/
            setData()
        }
    }
    
    @IBAction func moveToTomorrow(_ sender: AnyObject) {
        if Defaults[.isSignIn] == false {
            signUpAlert(viewController: self)
            self.voteCollectionView.deselectAllItems(animated: false)
            self.voteCollectionView.reloadData()
        } else {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: dateFormatter.date(from: selectedDate)!)
            //let tomorrowString = dateFormatter.string(from: tomorrow!)
            setSelectedDate(new: Time.sharedInstance.stringFromDateDotyyyyMMdd(date: tomorrow!))
            setCalendarNavigationView()
            //reloadOpenCalendarView(selectedDate: tomorrowString)
            /*if selectedDate == todayDate {
                if Date() < Time.sharedInstance.getAnounceStartTime() {
                    setTodayQuestion()
                } else {
                    setSelectedDatedData()
                }
            } else {
                setSelectedDatedData()
            }
            voteCollectionView.reloadData()*/
            setData()
        }
    }
    
    @IBAction func calendarOpenButton(_ sender: AnyObject) {
        if Defaults[.isSignIn] == false {
            signUpAlert(viewController: self)
            self.voteCollectionView.deselectAllItems(animated: false)
            self.voteCollectionView.reloadData()
        } else {
            calendarViewController?.delegate = self
            calendarViewController?.selectedDate = selectedDate
            calendarViewController?.modalPresentationStyle = .overCurrentContext
            present(calendarViewController!, animated: true, completion: nil)
        }
    }
    
    @IBAction func voteSendButton(_ sender: AnyObject) {
        if selectedItem != nil { //투표
            let parameters: Parameters = [
                "user_id" : Defaults[.id],
                "vote_date" : todayDate,
                "vote_answer" : selectedItem!
            ]
            
            Alamofire
                .request("http://onepercentserver.azurewebsites.net/OnePercentServer/insertVote.do", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .log(level: .verbose)
            
            let newVote = MyVote()
            newVote.myVoteDate = todayDate
            newVote.selectedNumber = selectedItem!
            
            try! uiRealm.write {
                uiRealm.add(newVote)
            }
            
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
        dateFormatter.dateFormat = "yyyy.MM.dd"
        voteCollectionView.allowsMultipleSelection = false
        calendarViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setSelectedDate(new: todayDate)
        //initCalendarFunction()
        ///
        dateformat()
        ///
        
        //reloadOpenCalendarView(selectedDate: todayDate)
        setCalendarNavigationView()
        
        /*if Date() < Time.sharedInstance.getAnounceStartTime() {
            setTodayQuestion()
        } else {
            setSelectedDatedData()
        }
        voteCollectionView.reloadData()*/
        setData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        stopTimer()
        self.voteCollectionView.deselectAllItems(animated: false)
        self.voteCollectionView.reloadData()
    }
    
    // MARK: - FilePrivate Function
    fileprivate func startTimer() {
        if timer != nil {
            stopTimer()
        }
        
        self.updateTodayLeftTime()
        timer = Timer.new(every: 0.5.second, updateTodayLeftTime)
        timer?.start()
    }
    
    fileprivate func updateTodayLeftTime() {
        dateformat()
    }
    
    fileprivate func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - dataformat
    func dateformat() {
        let now = Date()
        if selectedDate != todayDate {
            nowstate = "이전투표보는중"
            setView(isHidevoteSendButton: true, isHidevoteEntryWinnerView: false, isHidevoteCollectionView: false, isHidenowStateView: true,nowStateLabelTxt: "", timeInformationLabelTxt: "")
        } else if now > Time.sharedInstance.getAnounceStartTime() && now < Time.sharedInstance.getTomorrowVoteStartTime() {
            nowstate = "당첨자발표중"
            setView(isHidevoteSendButton: true, isHidevoteEntryWinnerView: false, isHidevoteCollectionView: false, isHidenowStateView: true,nowStateLabelTxt: "", timeInformationLabelTxt: "")
            
        } else if now > Time.sharedInstance.getVoteStartTime() && now < Time.sharedInstance.getVoteEndTime() {
            nowstate = "투표 중"
            voteSendButton.setTitle("투표하기", for: .normal)
            setView(isHidevoteSendButton: false, isHidevoteEntryWinnerView: true, isHidevoteCollectionView: true, isHidenowStateView: true,nowStateLabelTxt: "", timeInformationLabelTxt: "")
            
            if Defaults[.isSignIn] == true {
                if let lastDate = uiRealm.objects(MyVote.self).sorted(byKeyPath: "myVoteDate").last?.myVoteDate {
                    if lastDate == todayDate {
                        setView(isHidevoteSendButton: true, isHidevoteEntryWinnerView: true, isHidevoteCollectionView: false, isHidenowStateView: false,nowStateLabelTxt: "투표 완료", timeInformationLabelTxt: "결과 발표 : 06:45 PM")
                    }
                }
            } else {
                setView(isHidevoteSendButton: false, isHidevoteEntryWinnerView: true, isHidevoteCollectionView: true, isHidenowStateView: true,nowStateLabelTxt: "", timeInformationLabelTxt: "")
            }
        } else if now < Time.sharedInstance.getVoteStartTime() {
            nowstate = "투표 대기 중"
            setView(isHidevoteSendButton: true, isHidevoteEntryWinnerView: true, isHidevoteCollectionView: false, isHidenowStateView: false,nowStateLabelTxt: "투표 준비 중", timeInformationLabelTxt: "투표 시작 : 06:00 AM")
            
            voteSendButton.setTitle(nowstate, for: .normal)
        } else  if now < Time.sharedInstance.getAnounceStartTime() {
            nowstate = "결과 집계 중"
            setView(isHidevoteSendButton: true, isHidevoteEntryWinnerView: true, isHidevoteCollectionView: false, isHidenowStateView: false,nowStateLabelTxt: "결과 집계 중", timeInformationLabelTxt: "결과 발표 : 06:45 PM")
        } else {
            
        }
    }
    
    //func initCalendarFunction() {
    //    calendarViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController) //viewDidLoad
    //    selectedDate = todayDate //setSelectedDate
    //}
    
    // MARK: - UI Set Function
    func setView(isHidevoteSendButton: Bool, isHidevoteEntryWinnerView: Bool, isHidevoteCollectionView: Bool, isHidenowStateView: Bool,nowStateLabelTxt: String, timeInformationLabelTxt: String) {
        self.voteSendButton.isHidden = isHidevoteSendButton
        self.voteEntryWinnerView.isHidden = isHidevoteEntryWinnerView
        self.voteCollectionView.allowsSelection = isHidevoteCollectionView
        self.nowStateStackView.isHidden = isHidenowStateView
        self.nowStateLabel.text = nowStateLabelTxt
        self.timeInformationLabel.text = timeInformationLabelTxt
    }
    
    func setView(question: String, entryAmount: String, winnerAmount: String) {
        self.questionLabel.text = question
        self.entryNumberLabel.text = entryAmount
        self.winnerNumberLabel.text = "오늘의 1% 는 " + winnerAmount + " 명 입니다"
    }
    
    func setCalendarNavigationView() {
        calendarOpenButton.setTitle(selectedDate, for: .normal)

        if selectedDate == todayDate {
            moveToTomorrow.isHidden = true
        } else if selectedDate == Time.sharedInstance.getAppStartStringDate() {
            moveToYesterDay.isHidden = true
        } else {
            moveToTomorrow.isHidden = false
            moveToYesterDay.isHidden = false
        }
    }
    
    /*func reloadOpenCalendarView(selectedDate: String) { //ui setNavigationView // , data setSelectedDate 함수로 나누기
        self.selectedDate = selectedDate
        calendarOpenButton.setTitle(selectedDate, for: .normal)
        let dateSelectedDate = dateFormatter.date(from: selectedDate)
        
        if dateSelectedDate?.compare(Time.sharedInstance.getAppStartDate()) == ComparisonResult.orderedSame {
            moveToYesterDay.isHidden = true
        } else {
            moveToYesterDay.isHidden = false
        }
        
        // TODO: 날짜비교로 수정하기
        if selectedDate == todayDate { moveToTomorrow.isHidden = true }
        else { moveToTomorrow.isHidden = false }
    }*/
    
   
    
    // MARK: - Data Set Function
    func setData() {
        if selectedDate == todayDate {
            if Date() < Time.sharedInstance.getAnounceStartTime() {
                setTodayQuestion()
            } else {
                setSelectedDatedData()
            }
        } else {
            setSelectedDatedData()
        }
        voteCollectionView.reloadData()
    }
    
     func findMostVotedIndex() { //고민
        let maxN = counts.reduce(0) { currentMax, i in max(currentMax, i) }
        maxVotedIndex = counts.index(of: maxN)
    }
    
    func setSelectedDate(new date: String) {
        selectedDate = date
    }
    
    func setTodayQuestion() { //고민
        Alamofire
            .request("http://onepercentserver.azurewebsites.net/OnePercentServer/todayQuestion.do")
            .log(level: .verbose)
            .responseObject { (response: DataResponse<QuestionResponse>) in
                if let todayQuestion = response.result.value?.todayQuestion {
                    for question in todayQuestion {
                        self.questionLabel.text = question.question
                        //                            if let ex1 = question.ex1 {
                        //                                self.examples[0] = ex1
                        //                            } else { self.examples[0] = "데이터없음"}
                        //                            if let ex2 = question.ex2 {
                        //                                self.examples[1] = ex2
                        //                            } else { self.examples[1] = "데이터없음" }
                        //                            if let ex3 = question.ex3 {
                        //                                self.examples[2] = ex3
                        //                            } else { self.examples[2] = "데이터없음" }
                        //                            if let ex4 = question.ex4 {
                        //                                self.examples[3] = ex4
                        //                            } else { self.examples[3] = "데이터없음" }
                        self.examples[0] = question.ex1
                        self.examples[1] = question.ex2
                        self.examples[2] = question.ex3
                        self.examples[3] = question.ex4
                    }
                }
        }
    }
    
    func setSelectedDatedData() { //고민
        /*guard let todayVoteInfo = uiRealm.objects(Vote.self).filter("voteDate == '\(selectedDate!)'").first else {
            return
        }*/
         if let todayVoteInfo = uiRealm.objects(Vote.self).filter("voteDate == '\(selectedDate!)'").first {
        
        //ui
        self.questionLabel.text = (todayVoteInfo.question)
        
        //TODO: 함수화??
        examples[0] = todayVoteInfo.ex1
        examples[1] = todayVoteInfo.ex2
        examples[2] = todayVoteInfo.ex3
        examples[3] = todayVoteInfo.ex4
        
        counts[0] = todayVoteInfo.count1
        counts[1] = todayVoteInfo.count2
        counts[2] = todayVoteInfo.count3
        counts[3] = todayVoteInfo.count4
        
        self.entryAmount = todayVoteInfo.entryAmount
        
        //ui
        self.entryNumberLabel.text = String(entryAmount)
        self.winnerNumberLabel.text = "오늘의 1% 는" + String(todayVoteInfo.winnerAmount) + "명 입니다"
        
        findMostVotedIndex()
        
        //setView(question: todayVoteInfo.question, entryAmount: String(todayVoteInfo.entryAmount), winnerAmount: String(todayVoteInfo.winnerAmount))
         } else {
            //setView(question: "aa", entryAmount: "0", winnerAmount: "0")


        }
    }

}

// MARK: - extension UICollectionViewDataSource
extension VoteViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return examples.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = voteCollectionView.dequeueReusableCell(withReuseIdentifier: "voteCollectionViewCell", for: indexPath) as! VoteCollectionViewCell
        cell.questionLabel.text = examples[indexPath.row]
        
        cell.mySelectPresentImageView.isHidden = true
        
        if nowstate == "당첨자발표중" || Time.sharedInstance.dateFromStringDotyyyyMMdd(date: selectedDate) != Time.sharedInstance.dateFromStringDotyyyyMMdd(date: todayDate) {
            cell.voteResultView.isHidden = false
            let count = counts[indexPath.row]
            let rate:CGFloat
            if entryAmount == 0 { rate = 0 }
            else { rate = CGFloat(count) / CGFloat(entryAmount) }
            cell.countLabel.text = String(count)
            cell.chargeImageView.frame = CGRect(origin: cell.bounds.origin , size: CGSize(width: cell.frame.width * rate, height: cell.frame.height))
            if let maxVotedIndex = maxVotedIndex {
                if maxVotedIndex == indexPath.row {
                    cell.chargeImageView.backgroundColor = UIColor(red: 85, green: 160, blue: 214)
                } else {
                    cell.chargeImageView.backgroundColor = UIColor(red: 158, green: 167, blue: 185)
                }
            }
            setView(isHidevoteSendButton: true, isHidevoteEntryWinnerView: false, isHidevoteCollectionView: false, isHidenowStateView: true,nowStateLabelTxt: "", timeInformationLabelTxt: "")
        } else {
            cell.voteResultView.isHidden = true
            cell.chargeImageView.frame = CGRect(origin: cell.bounds.origin , size: CGSize(width: cell.frame.width * 0, height: cell.frame.height))
        }
        
        if Defaults[.isSignIn] == true {
            let selectedDateVote = uiRealm.objects(MyVote.self).filter("myVoteDate == '\(selectedDate!)'")
            let selectedDateVoteNumber = selectedDateVote.first?.selectedNumber
            if indexPath.row == selectedDateVoteNumber {
                cell.mySelectPresentImageView.isHidden = false
                cell.backgroundColor = UIColor(red: 85, green: 160, blue: 214)
                cell.questionLabel.tintColor = UIColor.white
            } else {
                cell.mySelectPresentImageView.isHidden = true
                cell.backgroundColor = UIColor(red: 217, green: 217, blue: 217)
            }
        }
        
        return cell
    }
}

// MARK: - extension UICollectionViewDelegate
extension VoteViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = voteCollectionView.cellForItem(at: indexPath)
        
        cell?.backgroundColor = UIColor(red: 85, green: 160, blue: 214)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Defaults[.isSignIn] == false {
            signUpAlert(viewController: self)
            self.voteCollectionView.deselectAllItems(animated: false)
            self.voteCollectionView.reloadData()
        }
        
        if let cell = voteCollectionView.cellForItem(at: indexPath) {
            selectedItem = indexPath.row
            cell.backgroundColor = UIColor(red: 85, green: 160, blue: 214)
        }
        // TODO: 셀선택시 fatal error: unexpectedly found nil while unwrapping an Optional value
        
        if let voteCollectionViewCell = voteCollectionView.cellForItem(at: indexPath) as? VoteCollectionViewCell {
            voteCollectionViewCell.mySelectPresentImageView.isHidden = false
        }
        //        voteCollectionViewCell.questionLabel.textColor = UIColor.white
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = voteCollectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = UIColor(red: 217, green: 217, blue: 217)
        }
        let voteCollectionViewCell = voteCollectionView.cellForItem(at: indexPath) as! VoteCollectionViewCell
        voteCollectionViewCell.mySelectPresentImageView.isHidden = true
        //        voteCollectionViewCell.questionLabel.textColor = UIColor.black
    }
}

// MARK: - extension UICollectionViewDelegateFlowLayout
extension VoteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: voteCollectionView.frame.width, height: (voteCollectionView.frame.height - 40) / 4)
        return cellSize
    }
}

// MARK: - extension CalendarViewControllerDelegate
extension VoteViewController: CalendarViewControllerDelegate {
    func dateSelectDone(date: String) {
        setSelectedDate(new: date)
        setCalendarNavigationView()
        //reloadOpenCalendarView(selectedDate: date)
        // TODO: 오늘날짜 선택시 발표전이면 todayquestion에서 데이터 받기 그외 setSelectedDatedData에서 받기
        /*if date == todayDate {
            if Date() < Time.sharedInstance.getAnounceStartTime() {
                setTodayQuestion()
            } else {
                setSelectedDatedData()
            }
        } else {
            setSelectedDatedData()
        }
        voteCollectionView.reloadData()*/
        setData()
    }
}

// MARK: - extension UICollectionView
extension UICollectionView {
    func deselectAllItems(animated: Bool = false) {
        for indexPath in self.indexPathsForSelectedItems ?? [] {
            self.deselectItem(at: indexPath, animated: animated)
            self.cellForItem(at: indexPath)?.backgroundColor = UIColor(red: 217, green: 217, blue: 217)
        }
    }
}
