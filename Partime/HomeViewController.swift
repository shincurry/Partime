//
//  HomeViewController.swift
//  Partime
//
//  Created by ShinCurry on 15/12/29.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        galaryTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "nextGalaryImage", userInfo: nil, repeats: true)
        locationButton.title = defaults.valueForKey("location") as! String + " ▾"
    }
    
    // 可能会调用多次
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initialGalary()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Properties
    @IBOutlet weak var locationButton: UIBarButtonItem!
    var location: String {
        get {
            return defaults.valueForKey("location") as! String
        }
        set {
            defaults.setObject(newValue, forKey: "location")
            locationButton.title = newValue + " ▾"
        }
    }
    
    var galaryTimer: NSTimer!
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

// MARK: - Galary Scroll View
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollViewWidth = galaryScrollView.frame.size.width
        let offsetX = galaryScrollView.contentOffset.x
        galaryPageControl.currentPage = (Int)((offsetX + scrollViewWidth / 2) / scrollViewWidth)
    }
    
    private func initialGalary() {
        let galarySize = galaryScrollView.frame.size
        for index in 0..<galaryTotalCount {
            let imageX = CGFloat(index) * galarySize.width
            let imageView = UIImageView(frame: CGRectMake(imageX, 0, galarySize.width, galarySize.height))
            imageView.image = UIImage(named: "GalaryDefault-\(index+1)")
            imageView.contentMode = .ScaleAspectFill
            galaryScrollView.addSubview(imageView)
        }
        let contentWidth = galarySize.width * CGFloat(galaryTotalCount)
        galaryScrollView.contentSize = CGSizeMake(contentWidth, 0)
        galaryPageControl.numberOfPages = galaryTotalCount
    }
    
    func nextGalaryImage() {
        let currentPage = (galaryPageControl.currentPage + 1) % galaryTotalCount
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
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HalfHomeNavigatorCell", forIndexPath: indexPath) as! HalfHomeNavigatorCollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            cell.icon.image = UIImage(named: "./beifang/b\(indexPath.row%3 + 1).jpg")
            return cell
        }
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
