//
//  HomeViewController.swift
//  Partime
//
//  Created by ShinCurry on 15/12/29.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let tab = tabBarController {
            tab.tabBar.tintColor = UIColor.whiteColor()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initialGalary()
//        initialJobsTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var galaryScrollView: UIScrollView!
    @IBOutlet weak var galaryPageControl: UIPageControl!
    let galaryTotalCount = 3

    
    @IBOutlet weak var homeCollection: UICollectionView!

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showGalaryDetailsSegue":
                let view = segue.destinationViewController as! GalaryDetailsViewController
                view.detailsLink = "https://windisco.com" as String?
            case "showJobDetailsSegue":
                let view = segue.destinationViewController as! JobDetailsViewController
                view.id = 333 as Int?
            default: break
            }
        }
    }


}

// BUG: 图片轮播有时候会乱跳
// MARK: - Galary Scroll View
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollViewWidth = galaryScrollView.frame.size.width
        let offsetX = galaryScrollView.contentOffset.x
        let currentPage = (Int)((offsetX + scrollViewWidth / 2) / scrollViewWidth)
//        let currentPage = (Int)((offsetX+scrollViewWidth) / scrollViewWidth - 1)
        galaryPageControl.currentPage = currentPage
    }
    
    private func initialGalary() {
        let galaryWidth = galaryScrollView.frame.size.width
        let galaryHeight = galaryScrollView.frame.size.height
        let galaryY: CGFloat = 0
        
        for index in 0..<galaryTotalCount {
            let imageX = CGFloat(index) * galaryWidth
            let imageView = UIImageView(frame: CGRectMake(imageX, galaryY, galaryWidth, galaryHeight))
            imageView.image = UIImage(named: "GalaryDefault-\(index+1)")
            imageView.contentMode = .ScaleAspectFill
            galaryScrollView.addSubview(imageView)
        }
        
        let contentWidth = galaryWidth * CGFloat(galaryTotalCount)
        galaryScrollView.contentSize = CGSizeMake(contentWidth, 0    )
        galaryScrollView.delegate = self
        galaryPageControl.numberOfPages = galaryTotalCount
        galaryPageControl.currentPage = 0
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "nextGalaryImage", userInfo: nil, repeats: true)
    }
    
    func nextGalaryImage() {
        let currentPage = (galaryPageControl.currentPage + 1) % galaryTotalCount
        let galaryViewWidth = galaryScrollView.frame.size.width
        let offsetX = CGFloat(currentPage) * galaryViewWidth
        galaryScrollView.setContentOffset(CGPointMake(offsetX, 0), animated: true)
    }
}


/// MARK: - Home Navigator Collection Delegate and DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func initialCollection() {
        homeCollection.backgroundColor = UIColor.whiteColor()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // temp code
        if section == 1 {
            return 1
        }
        if section == 2 {
            return 2
        }
        
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FullHomeNavigatorCell", forIndexPath: indexPath) as! FullHomeNavigatorCollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            cell.picture.image = UIImage(named: "./beifang/f1.jpg")
            return cell
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HalfHomeNavigatorCell", forIndexPath: indexPath) as! HalfHomeNavigatorCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        cell.icon.image = UIImage(named: "./beifang/b\(indexPath.row%3 + 1).jpg")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        } else {
            return CGSize(width: 50, height: 30)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let totalWidth = homeCollection.frame.width
        let cellHeight = CGFloat(70)

        if indexPath.section == 1 {
            return CGSize(width: totalWidth, height: cellHeight + 20)
        }
        let cellWidth = totalWidth / 2.0 - 1.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
