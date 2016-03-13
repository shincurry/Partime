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
        galleryTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "nextGalleryImage", userInfo: nil, repeats: true)
        locationButton.title = defaults.valueForKey("location") as! String + " ▾"
        initialViewStyle()
        
        
    }
    
    // 可能会调用多次
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initialGallery()
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
    
    var galleryTimer: NSTimer!
    @IBOutlet weak var galleryScrollView: UIScrollView!
    @IBOutlet weak var galleryPageControl: UIPageControl!
    let galleryTotalCount = 3

    @IBOutlet weak var homeCollection: UICollectionView!


}

extension HomeViewController {
    private func initialViewStyle() {
        automaticallyAdjustsScrollViewInsets = false
        if let navigator = navigationController {
            navigator.navigationBar.barTintColor = Theme.mainColor
        }
    }
}

// MARK: - Navigation
extension HomeViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowGalaryDetailsSegue":
                let view = segue.destinationViewController as! GalleryDetailsViewController
                view.detailsLink = "https://windisco.com" as String?
            default:
                break
            }
        }
    }
}

// MARK: - Gallery Scroll View
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollViewWidth = galleryScrollView.frame.size.width
        let offsetX = galleryScrollView.contentOffset.x
        galleryPageControl.currentPage = (Int)((offsetX + scrollViewWidth / 2) / scrollViewWidth)
    }
    
    private func initialGallery() {
        let gallerySize = galleryScrollView.frame.size
        for index in 0..<galleryTotalCount {
            let imageX = CGFloat(index) * gallerySize.width
            let imageView = UIImageView(frame: CGRectMake(imageX, 0, gallerySize.width, gallerySize.height))
            imageView.image = UIImage(named: "./pictures/gallery-\(index+1).jpg")
            imageView.contentMode = .ScaleAspectFill
            galleryScrollView.addSubview(imageView)
        }
        let contentWidth = gallerySize.width * CGFloat(galleryTotalCount)
        galleryScrollView.contentSize = CGSizeMake(contentWidth, 0)
        galleryPageControl.numberOfPages = galleryTotalCount
    }
    
    func nextGalleryImage() {
        let currentPage = (galleryPageControl.currentPage + 1) % galleryTotalCount
        let galleryViewWidth = galleryScrollView.frame.size.width
        let offsetX = CGFloat(currentPage) * galleryViewWidth
        galleryScrollView.setContentOffset(CGPointMake(offsetX, 0), animated: true)
    }
    
    @IBAction func galleryCurrentPageChange(sender: UIPageControl) {
        let imageX = CGFloat(galleryPageControl.currentPage) * galleryScrollView.frame.size.width
        galleryScrollView.setContentOffset(CGPointMake(imageX, 0), animated: true)
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
            cell.picture.image = UIImage(named: "./pictures/f1.jpg")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HalfHomeNavigatorCell", forIndexPath: indexPath) as! HalfHomeNavigatorCollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            cell.icon.image = UIImage(named: "./pictures/b\(indexPath.row%3 + 1).jpg")
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
