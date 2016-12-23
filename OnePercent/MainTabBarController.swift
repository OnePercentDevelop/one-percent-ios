//
//  MainTabBarController.swift
//  OnePercent
//
//  Created by 김혜원 on 2016. 11. 28..
//  Copyright © 2016년 김혜원. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let tabBarItems = tabBar.items! as [UITabBarItem]
//        
//        tabBarItems[0].title = "Week".localized
//        tabBarItems[0].image = UIImage.fontAwesomeIconWithName(FontAwesome.Calendar, textColor: UIColor.blueColor(), size: CGSizeMake(30, 30))

        //tabbar icon image 넣기
        let tabBarItems = tabBar.items! as [UITabBarItem]
        tabBarItems[1].image = UIImage(named: "icon_person")
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
