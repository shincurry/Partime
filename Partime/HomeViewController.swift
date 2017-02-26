//
//  HomeViewController.swift
//  Partime
//
//  Created by ShinCurry on 15/12/29.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SDWebImage
import MBProgressHUD

class HomeViewController: UIViewController {
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationButton.title = defaults.value(forKey: "location") as! String + " ▾"
        initialViewStyle()
        
        galleryTotalCount = defaults.integer(forKey: "galleryCount")
        
//        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(updateHomeView))
//        header?.lastUpdatedTimeLabel.isHidden = true
//        header?.stateLabel.isHidden = true
//        scrollView.mj_header = header
        
        updateHomeView()
        getJobs()
    }
    
    // 可能会调用多次
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        initialGallery()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Properties
    @IBOutlet weak var locationButton: UIBarButtonItem!
    var location: String {
        get {
            return defaults.value(forKey: "location") as! String
        }
        set {
            defaults.set(newValue, forKey: "location")
            locationButton.title = newValue + " ▾"
        }
        
    }
    
    let api = API.shared
    
    var jobsData: [JSON] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var galleryTimer: Timer!
    @IBOutlet weak var galleryScrollView: UIScrollView!
    @IBOutlet weak var galleryPageControl: UIPageControl!
    var galleryTotalCount = 1
    var galleryData: [GalleryData]?
    typealias GalleryData = (imgSrc: String, toLink: String)
    @IBOutlet weak var homeCollection: UICollectionView!

    @IBOutlet weak var recommendHeaderLeftView: UIView!
    @IBOutlet weak var recommendHeaderView: UIView!
    @IBOutlet weak var recommendHeaderMoreButton: UIButton!
    
    @IBOutlet weak var jobsTableView: UITableView!
    
    let tempData: [[String]] = [["德克士收银员", "100 元 / 日", "7:00 - 17:00", "重庆"],
        ["发传单", "60 元/日", "13:00-17:00", "重庆理工大学"],
        ["Disco cashier", "100/day", "7:00-17:00", "CQ"],
        ["名字一定要很长来测试 UI", "100 元/日", "7:00-17:00", "重庆"],
        ["发传单", "60 元 / 日", "13:00-17:00", "重庆理工大学"]]

    var collectionTitles = ["家政服务", "促销导购", "传单发放", "其他更多"]
    var collectionDescriptions = ["零碎繁杂家务事", "促销商品", "发放广告传单", "更多兼职工作"]
    
    
    func updateHomeView() {
        api.getAds() { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                if res["status"] == "success" {
                    self.galleryData = res["result"].array!.map() { gallery in
                        return (imgSrc: self.api.imageBaseUri + gallery["imgsrc"].stringValue, toLink: gallery["url"].stringValue)
                    }
                    self.galleryTotalCount = self.galleryData!.count
                    self.defaults.set(self.galleryTotalCount, forKey: "galleryCount")
                
                    self.initialGallery()
//                    self.scrollView.mj_header.endRefreshing()
                } else if res["status"] == "failure" {
                    print("failure")
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func getJobs() {
        let params: [String: AnyObject] = ["type":"" as AnyObject,
                                           "date": "" as AnyObject,
                                           "districtid": "" as AnyObject,
                                           "page": 1 as AnyObject]
        
        

        MBProgressHUD.showAdded(to: self.view, animated: true)
        api.getJobs(params) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                if res["status"] == "success" {
                    self.jobsData = res["result"].array!.enumerated().filter({ (index, _) in return (index<5) }).map({ (_, element) in return element })
                    self.jobsTableView.reloadData()
                } else if res["status"] == "failure" {
                    print("failure")
                }
                
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    @IBAction func refreshJobs(_ sender: UIButton) {
        getJobs()
    }
}

// MARK: - Initial View Style
extension HomeViewController {
    fileprivate func initialViewStyle() {
        automaticallyAdjustsScrollViewInsets = false
        if let navigator = navigationController {
            navigator.navigationBar.barTintColor = Theme.mainColor.withAlphaComponent(0.8)
        }
        if let tab = tabBarController {
            tab.tabBar.tintColor = Theme.mainColor
        }
        recommendHeaderView.backgroundColor = Theme.headerBackgroundColor
        recommendHeaderLeftView.backgroundColor = Theme.headerLeftColor
        recommendHeaderMoreButton.setTitleColor(Theme.mainColor, for: UIControlState())
    }
}

// MARK: - Navigation
extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowGalaryDetailsSegue":
                let view = segue.destination as! GalleryDetailsViewController
                view.detailsLink = galleryData?[galleryPageControl.currentPage].toLink
            case "ShowRecommendJobsSegue":
                let view = segue.destination as! JobsTableViewController
                view.navigationTitle = NSLocalizedString("recommendJobs", comment: "")
            default:
                break
            }
        }
    }
}

// MARK: - Gallery Scroll View
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewWidth = galleryScrollView.frame.size.width
        let offsetX = galleryScrollView.contentOffset.x
        galleryPageControl.currentPage = (Int)((offsetX + scrollViewWidth / 2) / scrollViewWidth)
    }
    
    fileprivate func initialGallery() {
        if let data = galleryData {
            let gallerySize = galleryScrollView.frame.size
            for index in 0..<galleryTotalCount {
                let imageX = CGFloat(index) * gallerySize.width
                let imageView = UIImageView(frame: CGRect(x: imageX, y: 0, width: gallerySize.width, height: gallerySize.height))
                imageView.sd_setImage(with: URL(string: data[index].imgSrc))
                imageView.contentMode = .scaleAspectFill
                galleryScrollView.addSubview(imageView)
            }
            let contentWidth = gallerySize.width * CGFloat(galleryTotalCount)
            galleryScrollView.contentSize = CGSize(width: contentWidth, height: 0)
            galleryPageControl.numberOfPages = galleryTotalCount
            galleryTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.nextGalleryImage), userInfo: nil, repeats: true)
        }
    }
    
    func nextGalleryImage() {
        let currentPage = (galleryPageControl.currentPage + 1) % galleryTotalCount
        let galleryViewWidth = galleryScrollView.frame.size.width
        let offsetX = CGFloat(currentPage) * galleryViewWidth
        galleryScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    @IBAction func galleryCurrentPageChange(_ sender: UIPageControl) {
        let imageX = CGFloat(galleryPageControl.currentPage) * galleryScrollView.frame.size.width
        galleryScrollView.setContentOffset(CGPoint(x: imageX, y: 0), animated: true)
    }
}


/// MARK: - Home Navigator Collection Delegate and DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate func initialCollection() {
        homeCollection.backgroundColor = UIColor.white
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.section == 1 {
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FullHomeNavigatorCell", forIndexPath: indexPath) as! FullHomeNavigatorCollectionViewCell
//            cell.backgroundColor = UIColor.whiteColor()
//            cell.picture.image = UIImage(named: "./pictures/f1.jpg")
//            return cell
//        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HalfHomeNavigatorCell", for: indexPath) as! HalfHomeNavigatorCollectionViewCell
            cell.title.text = collectionTitles[indexPath.row]
            cell.descriptionText.text = collectionDescriptions[indexPath.row]
            cell.backgroundColor = UIColor.white
//            cell.icon.image = UIImage(named: "./pictures/b\(indexPath.row%3 + 1).jpg")
            return cell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        } else {
            return CGSize(width: 50, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let totalWidth = homeCollection.frame.width
        let cellHeight = CGFloat(70)

        if indexPath.section == 1 {
            return CGSize(width: totalWidth, height: cellHeight + 20)
        }
        let cellWidth = totalWidth / 2.0 - 1.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tabBar = self.tabBarController {
            tabBar.selectedIndex = 1
            if let controller = tabBar.viewControllers![tabBar.selectedIndex].childViewControllers[0] as? AllJobsViewController  {
                switch indexPath.row {
                case 0:
                    controller.quickAccess(.lsjj)
                case 1:
                    controller.quickAccess(.cxdg)
                case 2:
                    controller.quickAccess(.cdff)
                case 3:
                    controller.quickAccess(.other)
                default:
                    break
                }
                
            }
        }
    }
}

// MARK: - Recommend Job Table View Delegate and DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendJobCell", for: indexPath) as! JobCell
        
        let data = jobsData[indexPath.row]
        if !data["district"].stringValue.isEmpty {
            cell.locationLabel.text = data["district"].stringValue
        }
        //        cell.timeLabel.text = data["dateBegin"].stringValue + "~" + data["dateEnd"].stringValue + " " + data["timeBegin"].stringValue + "~" + data["timeEnd"].stringValue
        
        if !data["dateBegin"].stringValue.isEmpty && !data["dateEnd"].stringValue.isEmpty {
            cell.timeLabel.text = data["dateBegin"].stringValue + " ~ " + data["dateEnd"].stringValue
        }
        cell.salaryLabel!.text = "\(data["salary"].stringValue)元/\(data["salaryType"].stringValue)"
        cell.salaryTypeLabel.text = data["salaryWhen"].stringValue
        cell.titleLabel.text = data["title"].stringValue
        cell.logoImage.image = UIImage(named: "Logo")
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return recommendHeaderView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }

}
