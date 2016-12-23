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
class VoteViewController: UIViewController {

    // MARK: - Property
    var selectedItem : Int? = nil
    @IBOutlet weak var voteCollectionView: UICollectionView!
    @IBOutlet weak var questionLabel: UILabel!
    //var question: String?
    var examples = [String]()
    
    @IBOutlet weak var voteEntryWinnerView: UIView!
    // MARK: - IBAction
    @IBAction func voteSendButton(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년MM월dd일"
        let todayDate = dateFormatter.string(from: Date())
        
        if selectedItem != nil {
            let parameters: Parameters = [
                "user_id" : Defaults[.id],
                "vote_date" : todayDate,
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

        // Do any additional setup after loading the view.
        
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

}

// MARK: - public function
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

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
