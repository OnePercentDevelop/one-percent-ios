//
//  WinnerViewController.swift
//  OnePercent
//
//  Created by 김혜원 on 2017. 2. 16..
//  Copyright © 2017년 김혜원. All rights reserved.
//

import UIKit

class WinnerViewController: UIViewController {

    var test = ["01000000000", "01000000000", "01000000000", "01000000000", "01000000000", "01000000000", "01000000000", "01000000000", "01000000000", "01000000000", "01000000000", "01000000000", "01000000000", "01000000000", "01000000000", "01000000000", "01000000000", "01000000000" ]
    
    
    @IBOutlet weak var winnerCollectionView: UICollectionView!
    @IBOutlet weak var calendarNavigationView: CalendarNavigationView!
    
    @IBOutlet weak var showMoreCollectionViewButton: UIButton!
    
    @IBAction func openSecondCollectionViewButton(_ sender: AnyObject) {
        winnerCollectionView.isScrollEnabled = true
//        print("origin:\(winnerCollectionView.bounds.origin)>>\(winnerCollectionView.frame.origin)")
        
        
        winnerCollectionView.frame = CGRect(origin: winnerCollectionView.frame.origin , size: CGSize(width: winnerCollectionView.frame.width, height: winnerCollectionView.frame.height + 10.0))
        showMoreCollectionViewButton.isHidden = true
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        winnerCollectionView.isScrollEnabled = false
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

extension WinnerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return test.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = winnerCollectionView.dequeueReusableCell(withReuseIdentifier: "winnerCollectionViewCell", for: indexPath) as! WinnerCollectionViewCell
        
        cell.winnerIdLabel.text = test[indexPath.row]
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionFooter:
            let footerView = winnerCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "winnerCollectionFooterView", for: indexPath) as! winnerCollectionFooterView
            footerView.info.text = "hi"
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    /*
     override func collectionView(_ collectionView: UICollectionView,
     viewForSupplementaryElementOfKind kind: String,
     at indexPath: IndexPath) -> UICollectionReusableView {
     //1
     switch kind {
     //2
     case UICollectionElementKindSectionHeader:
     //3
     let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
     withReuseIdentifier: "FlickrPhotoHeaderView",
     for: indexPath) as! FlickrPhotoHeaderView
     headerView.label.text = searches[(indexPath as NSIndexPath).section].searchTerm
     return headerView
     default:
     //4
     assert(false, "Unexpected element kind")
     }
     }
     */

}
