//
//  GuideViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/3/13.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initialGuideScrollView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var guidePageTotalCount = 3
    @IBOutlet weak var guideScrollView: UIScrollView!
    
    @IBOutlet weak var guidePageControl: UIPageControl!

}

// MARK: - Guide Scroll View
extension GuideViewController: UIScrollViewDelegate {
    fileprivate func initialGuideScrollView() {
        let guideSize = guideScrollView.frame.size
        for index in 0..<guidePageTotalCount {
            let imageX = CGFloat(index) * guideSize.width
            let imageView = UIImageView(frame: CGRect(x: imageX, y: 0, width: guideSize.width, height: guideSize.height))
            imageView.image = UIImage(named: "./pictures/launch-\(index+1).jpg")
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            guideScrollView.addSubview(imageView)
        }
        
        let contentWidth = guideSize.width * CGFloat(guidePageTotalCount)
        let contentHeight = guideScrollView.frame.size.height
        guideScrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        guidePageControl.numberOfPages = guidePageTotalCount
    }
    
    @IBAction func guideCurrentPageChange(_ sender: UIPageControl) {
        let imageX = CGFloat(guidePageControl.currentPage) * guideScrollView.frame.size.width
        guideScrollView.setContentOffset(CGPoint(x: imageX, y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewWidth = guideScrollView.frame.size.width
        let offsetX = guideScrollView.contentOffset.x
        guidePageControl.currentPage = (Int)((offsetX + scrollViewWidth / 2) / scrollViewWidth)
    }
    
}

extension GuideViewController {
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
