//
//  AppDelegate.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 10. 24..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import UIKit
import RealmSwift
//import Firebase
import Alamofire
import SwiftyUserDefaults
import Firebase
import GoogleSignIn
import FirebaseAuth

let uiRealm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //FIRApp.configure()
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        var url = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        if let lastDownloadedVoteResultDate = uiRealm.objects(Vote.self).sorted(byKeyPath: "voteDate").last?.voteDate {
            if lastDownloadedVoteResultDate != dateFormatter.string(from: Date()) {
                let oneDayAfterLastDownloadedDate = Calendar.current.date(byAdding: .day, value: 1, to: dateFormatter.date(from: lastDownloadedVoteResultDate)!)
                url = "http://onepercentserver.azurewebsites.net/OnePercentServer/voteResultSince.do?vote_date=\(dateFormatter.string(from: oneDayAfterLastDownloadedDate!))"

                Alamofire.request(url)
                    .log(level: .verbose)
                    .responseObject { (response: DataResponse<voteResultSince>) in
                        if let voteTotalResult = response.result.value?.voteTotalResult {
                            for n in voteTotalResult {
                                let voteResult = Vote()
                                voteResult.voteDate = n.voteDate
                                voteResult.question = n.question
                                voteResult.ex1 = n.ex1
                                voteResult.ex2 = n.ex2
                                voteResult.ex3 = n.ex3
                                voteResult.ex4 = n.ex4
                                voteResult.count1 = n.count1
                                voteResult.count2 = n.count2
                                voteResult.count3 = n.count3
                                voteResult.count4 = n.count4
                                voteResult.entryAmount = n.entryAmount
                                voteResult.winnerAmount = n.winnerAmount
                                try! uiRealm.write {
                                    uiRealm.add(voteResult)
                                }
                            }
                        }
                }

            }
            
        } else { //처음 앱 깔때
            url = "http://onepercentserver.azurewebsites.net/OnePercentServer/voteResult.do"
            Alamofire.request(url)
                .log(level: .verbose)
                .responseObject { (response: DataResponse<VoteResponse>) in
                    if let voteTotalResult = response.result.value?.voteTotalResult {
                        for n in voteTotalResult {
                            let voteResult = Vote()
                            voteResult.voteDate = n.voteDate
                            voteResult.question = n.question
                            voteResult.ex1 = n.ex1
                            voteResult.ex2 = n.ex2
                            voteResult.ex3 = n.ex3
                            voteResult.ex4 = n.ex4
                            voteResult.count1 = n.count1
                            voteResult.count2 = n.count2
                            voteResult.count3 = n.count3
                            voteResult.count4 = n.count4
                            voteResult.entryAmount = n.entryAmount
                            voteResult.winnerAmount = n.winnerAmount
                            try! uiRealm.write {
                                uiRealm.add(voteResult)
                            }
                        }
                    }
            }
            // 사용자가 투표했던 목록 가져오기
            url = "onepercentserver.azurewebsites.net/OnePercentServer/userVoteList.do?user_id=\(Defaults[.id])"
            Alamofire.request(url)
                .log(level: .verbose)
                .responseObject { (response: DataResponse<MyVoteResponse>) in
                    if let myVoteResult = response.result.value?.uservoteList {
                        for n in myVoteResult {
                            let myVote = MyVote()
                            myVote.myVoteDate = n.myVoteDate
                            myVote.selectedNumber = n.selectedNumber
                            try! uiRealm.write {
                                uiRealm.add(myVote)
                            }
                        }
                    }
            }
            
        }
        
        if let lastDownloadedPrizeDate = uiRealm.objects(Prize.self).sorted(byKeyPath: "prizeDate").last?.prizeDate {
            if lastDownloadedPrizeDate != dateFormatter.string(from: Date()) {
                let oneDayAfterLastDownloadedDate = Calendar.current.date(byAdding: .day, value: 1, to: dateFormatter.date(from: lastDownloadedPrizeDate)!)
                url = "http://onepercentserver.azurewebsites.net/OnePercentServer/WinnerResultSince.do"
                Alamofire.request(url)
                    .log(level: .verbose)
                    .responseObject { (response: DataResponse<PrizeResponse>) in
                        if let winnerResult = response.result.value?.winnerResult {
                            for winner in winnerResult {
                                let prize = Prize()
                                prize.prizeDate = winner.prizeDate
                                prize.winner = winner.winner
                                prize.giftUrl = winner.giftUrl
                                prize.giftName = winner.giftName
                                
                                try! uiRealm.write {
                                    uiRealm.add(prize)
                                }
                            }
                        }
                }


            }
            
        } else {
            url = "http://onepercentserver.azurewebsites.net/OnePercentServer/WinnerResult.do"
            Alamofire.request(url)
                .log(level: .verbose)
                .responseObject { (response: DataResponse<PrizeResponse>) in
                    if let winnerResult = response.result.value?.winnerResult {
                        for winner in winnerResult {
                            let prize = Prize()
                            prize.prizeDate = winner.prizeDate
                            prize.winner = winner.winner
                            prize.giftUrl = winner.giftUrl
                            prize.giftName = winner.giftName
                            
                            try! uiRealm.write {
                                uiRealm.add(prize)
                            }
                        }
                    }
            }
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        return true
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
        }
    
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

