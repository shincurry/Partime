//
//  ProfileViewController.swift
//  Partime
//
//  Created by ShinCurry on 15/12/29.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewLayer()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var jobCollection: UICollectionView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    private func initialViewLayer() {
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.shadowColor = UIColor.blackColor().CGColor
        profileImage.layer.shadowOpacity = 0.8
        

    }
}

//extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        return UICollectionViewCell()
//    }
//}