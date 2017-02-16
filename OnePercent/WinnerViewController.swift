//
//  WinnerViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 2. 16..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import UIKit

class WinnerViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstWinnerCollectionView: UIScrollView!

    @IBOutlet weak var secondWinnerCollectionView: UICollectionView!
    
    @IBOutlet weak var calendarNavigationView: CalendarNavigationView!
    
    @IBOutlet weak var openSecondCollectionViewButton: UIButton!
    @IBAction func openSecondCollectionViewButton(_ sender: AnyObject) {
        scrollView.isScrollEnabled = true
        secondWinnerCollectionView.isHidden = false
        openSecondCollectionViewButton.isHidden = true

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = false
        secondWinnerCollectionView.isHidden = true
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
