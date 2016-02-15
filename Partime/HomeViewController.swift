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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        if let selection = jobsTableView.indexPathForSelectedRow {
//            jobsTableView.deselectRowAtIndexPath(selection, animated: true)
//        }
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
        galaryPageControl.currentPage = currentPage
    }
    
    private func initialGalary() {
        let galaryWidth = galaryScrollView.frame.size.width
        let galaryHeight = galaryScrollView.frame.size.height
        let galaryY: CGFloat = 0
        
        for index in 0..<galaryTotalCount {
            let imageView = UIImageView()
            let imageX = CGFloat(index) * galaryWidth
            imageView.frame = CGRectMake(imageX, galaryY, galaryWidth, galaryHeight)
            let imageName = "GalaryDefault-\(index+1)"
            imageView.image = UIImage(named: imageName)
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
        var currentPage = galaryPageControl.currentPage
        currentPage = ++currentPage >= galaryTotalCount ? 0 : currentPage
        let galaryViewWidth = galaryScrollView.frame.size.width
        let offsetX = CGFloat(currentPage) * galaryViewWidth
        galaryScrollView.setContentOffset(CGPointMake(offsetX, 0), animated: true)
    }
    @IBAction func galaryCurrentPageChange(sender: UIPageControl) {
        let imageX = CGFloat(galaryPageControl.currentPage) * galaryScrollView.frame.size.width
        galaryScrollView.setContentOffset(CGPointMake(imageX, 0), animated: true)
        
    }
}


/// MARK: - Home Navigator Collection Delegate and DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func initialCollection() {
        homeCollection.backgroundColor = UIColor.whiteColor()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeNavigatorCell", forIndexPath: indexPath) as! HomeNavigatorCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
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
        let cellWidth = totalWidth / 2.0 - 1.0
        let cellHeight = CGFloat(75)
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
