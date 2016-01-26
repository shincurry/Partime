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
        initialGalary()
        initialJobsTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var galaryScrollView: UIScrollView!
    @IBOutlet weak var galaryPageControl: UIPageControl!
    let galaryTotalCount = 3
    
    @IBOutlet weak var jobsTableView: UITableView!
    @IBAction func showMoreButton(sender: UIButton) {
        
    }
    
    @IBOutlet weak var headerView: UIView!

    
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

// MARK: - UITableView Delegate and DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("JobTableViewCell", forIndexPath: indexPath) as! JobsTableViewCell
        cell.initialization(index: indexPath.row, title: "Disco cashier", salary: "100 / day", time: "7:00 - 17:00", workplace: "CQ")
        return cell
    }
    
    private func initialJobsTableView() {
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(36)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.alpha = 0.8
    }
}

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