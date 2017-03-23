//
//  MoreMainTableViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 3. 10..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import UIKit

class MoreMainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected  \(indexPath.row)")
        var viewController: UIViewController? = nil
        switch indexPath.row {
        case 0:
            viewController = self.storyboard?.instantiateViewController(withIdentifier: "MoreTableViewController") as! MoreTableViewController
            viewController?.title = "계정관리"
            
        case 1:
            viewController = self.storyboard?.instantiateViewController(withIdentifier: "MoreTableViewController")
            viewController?.title = "공지사항"
            
        case 2:
            viewController = self.storyboard?.instantiateViewController(withIdentifier: "MoreTableViewController")
            viewController?.title = "고객센터"

        case 3:
            viewController = self.storyboard?.instantiateViewController(withIdentifier: "pushAlarmTableViewController")
            viewController?.title = "push알림"

        case 4:
            viewController = self.storyboard?.instantiateViewController(withIdentifier: "MoreWithViewViewController")
            viewController?.title = "버전정보"
        
        default:
            ()
        }
        if let viewController = viewController {
            self.navigationController?.pushViewController(viewController , animated: true)

        }
    }

    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
