//
//  MoreMainTableViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 3. 10..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class MoreMainTableViewController: UITableViewController {

    @IBOutlet weak var myIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myIDLabel.text = Defaults[.id]
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected  \(indexPath.row)")
        switch indexPath.row {
        case 0: break
        case 1: break //webview연결
        case 2:
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "pushAlarmTableViewController")
            viewController?.title = "push알림"
            self.navigationController?.pushViewController(viewController! , animated: true)
        default:
            ()
        }
    }
}
