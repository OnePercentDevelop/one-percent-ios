//
//  PushAlarmTableViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 3. 15..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import UIKit

class PushAlarmTableViewController: UITableViewController {

    @IBOutlet weak var pushAlarmVoteStart: UISwitch!
    @IBOutlet weak var silenceVoteStart: UISwitch!
    
    @IBOutlet weak var pushAlarmVoteEnd: UISwitch!
    @IBOutlet weak var silenceVoteEnd: UISwitch!
    
    @IBOutlet weak var pushAlarmWinner: UISwitch!
    @IBOutlet weak var silenceWinner: UISwitch!
    
    @IBAction func pushAlarmVoteStart(_ sender: Any) {
        if !pushAlarmVoteStart.isOn {
            silenceVoteStart.isOn = false
        }
    }
    
    @IBAction func silenceVoteStart(_ sender: Any) {
        
    }
    
    @IBAction func pushAlarmVoteEnd(_ sender: Any) {
        if !pushAlarmVoteEnd.isOn {
            silenceVoteEnd.isOn = false
        }
    }
    
    @IBAction func silenceVoteEnd(_ sender: Any) {
    }
    
    @IBAction func pushAlarmWinner(_ sender: Any) {
        if !pushAlarmWinner.isOn {
            silenceWinner.isOn = false
        }
    }
    
    @IBAction func silenceWinner(_ sender: Any) {
    }
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
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
