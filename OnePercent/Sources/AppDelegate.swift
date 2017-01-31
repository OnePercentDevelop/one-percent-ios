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

let uiRealm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //FIRApp.configure()
        // Override point for customization after application launch.

        var url = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        if let lastDownloadedVoteResultDate = uiRealm.objects(Vote.self).last?.voteDate {
            if lastDownloadedVoteResultDate != dateFormatter.string(from: Date()) {
                let oneDayAfterLastDownloadedDate = Calendar.current.date(byAdding: .day, value: 1, to: dateFormatter.date(from: lastDownloadedVoteResultDate)!)
                url = "http://onepercentserver.azurewebsites.net/OnePercentServer/voteResultSince.do?vote_date=\(dateFormatter.string(from: oneDayAfterLastDownloadedDate!))"
            }
        } else { //처음 앱 깔때
            url = "http://onepercentserver.azurewebsites.net/OnePercentServer/voteResult.do"
        }
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
        
        return true
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

