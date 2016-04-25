//
//  JobDetailsTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/2/27.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import SwiftyJSON

class JobDetailsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = API.token {
        } else {
            joinButton.enabled = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        initialViewStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Properties
    
    @IBOutlet weak var navigatorTitle: UINavigationItem!
    
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateScoreLabel: UILabel!
    
    
    @IBOutlet weak var jobDetailsText: UITextView!
    
    
    @IBOutlet weak var workDateLabel: UILabel!
    
    @IBOutlet weak var workTimeLabel: UILabel!
    
    
    @IBOutlet weak var companyLogoImage: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var contactQQImage: UIImageView!
    @IBOutlet weak var contactQQButton: UIButton!
    
    @IBOutlet weak var contactTelephoneImage: UIImageView!
    @IBOutlet weak var contactTelephoneButton: UIButton!
    
    @IBOutlet weak var contactEmailImage: UIImageView!
    
    @IBOutlet weak var contactEmailButton: UIButton!
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var mapLabel: UILabel!
    

    let api = API.shared
    
    var id: String? {
        didSet {
            api.getJobDetails(["id": id!]) { result in
                switch result {
                case .Success:
                    
                    self.jobData = JSON(data: result.value!)
                    
                case .Failure(let error):
                    print(error)
                }
                self.loadData()
            }

        }
    }
    var jobData: JSON?
    
    
    @IBOutlet weak var joinButton: UIButton!
    @IBAction func join(sender: UIButton) {
        if let id = self.id {
            api.requestAJob(["access_token": API.token!, "id": id]) { result in
                switch result {
                case .Success:
                    let data = JSON(data: result.value!)
                    if data["status"].stringValue == "success" {
                        let alertController = UIAlertController(title: "Success", message: "Join successfully", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true) {
                        }
                    }
                case .Failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
}

// MARK: - Table View Delegate and DataSource
extension JobDetailsTableViewController {
    func tempData() {
        picture.image = UIImage(named: "./pictures/gallery-1.jpg")
        navigatorTitle.title = "某不知名兼职工作"
        titleLabel.text = "某不知名兼职工作"
        locationLabel.text = "重庆理工大学"
        timeLabel.text = "2016-1-1"
        rateLabel.text = RateStar(score: 4).getStars()
        jobDetailsText.text = "背书:\n我一再翻阅这些痛苦的回忆，一面不断地自问，是否在那个阳光灿烂的遥远的夏天，我生活中发狂的预兆已经开始，还是我对那个孩子的过度欲望，只是一种与生俱来的怪癖的最早迹象呢？在我努力分析自己的渴望、动机和行为等等的时候，我总陷入一种追忆往事的幻想，这种幻想为分析官能提供了无限的选择，并且促使想象中的每一条线路在我过去那片复杂得令人发疯的境界中漫无止境地一再往外分岔。可是，我深信，从某种魔法和宿命的观点而言，洛丽塔是从安娜贝尔开始的。\n我一再翻阅这些痛苦的回忆，一面不断地自问，是否在那个阳光灿烂的遥远的夏天，我生活中发狂的预兆已经开始，还是我对那个孩子的过度欲望，只是一种与生俱来的怪癖的最早迹象呢？在我努力分析自己的渴望、动机和行为等等的时候，我总陷入一种追忆往事的幻想，这种幻想为分析官能提供了无限的选择，并且促使想象中的每一条线路在我过去那片复杂得令人发疯的境界中漫无止境地一再往外分岔。可是，我深信，从某种魔法和宿命的观点而言，洛丽塔是从安娜贝尔开始的。"
    }
    
    func loadData() {
        if let data = jobData {
            print(data)
            picture.image = UIImage(named: "./pictures/gallery-1.jpg")
            navigatorTitle.title = data["title"].stringValue
         
            titleLabel.text = data["title"].stringValue
            locationLabel.text = data["cityid"].stringValue
            
            timeLabel.text = data["begindate"].stringValue
            workDateLabel.text = "\(data["begindate"].stringValue) ~ \(data["enddate"].stringValue)"
            workTimeLabel.text = data["timebegin"].stringValue + " ~ " + data["timeend"].stringValue
            
            rateLabel.text = RateStar(score: 0).getStars()
            rateScoreLabel.text = "0"
            
//            jobDetailsText.text = data[""]

            
            contactTelephoneButton.titleLabel!.text = data["mobile"].stringValue
        } else {
            tempData()
        }
        
        
        

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if indexPath.section == 0 && indexPath.row == 0 {
        
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 12
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cellHeight = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        if indexPath.section == 1 && indexPath.row == 1 {
            let originalHeight = jobDetailsText.frame.height
            let fullHeight = jobDetailsText.fullSize().height
            cellHeight += fullHeight - originalHeight
        }
        
        return cellHeight

    }
}

// MARK: - View Style
extension JobDetailsTableViewController {
    private func initialViewStyle() {
        tableView.backgroundColor = Theme.backgroundColor
        companyLogoImage.clipsToBounds = true
        companyLogoImage.layer.cornerRadius = companyLogoImage.frame.size.width / 2
        locationImage.tintColor = Theme.mainColor
        timeImage.tintColor = Theme.mainColor
        contactQQImage.tintColor = Theme.mainColor
        contactTelephoneImage.tintColor = Theme.mainColor
        contactEmailImage.tintColor = Theme.mainColor
        mapImage.tintColor = Theme.mainColor
    }
}

// MARK: - Contact Quick Launch
extension JobDetailsTableViewController {
    @IBAction func calling(sender: UIButton) {
        let phoneNumber = sender.currentTitle!
        let url = NSURL(string: "tel://\(phoneNumber)")!
        let alertTitle = NSLocalizedString("contactAlertTitle", comment: "")
        let alertMessage = String.localizedStringWithFormat(NSLocalizedString("contactAlertMessage", comment: ""), phoneNumber)
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default) { (action) in
            UIApplication.sharedApplication().openURL(url)
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func mailing(sender: UIButton) {
        let email = sender.currentTitle!
        let url = NSURL(string: "mailto://\(email)")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func qq(sender: UIButton) {
        let qq = sender.currentTitle!
        let url = NSURL(string: "mqq://\(qq)")!
        UIApplication.sharedApplication().openURL(url)
        
    }
}

extension UITextView {
    func fullSize() -> CGSize {
        return self.sizeThatFits(self.contentSize)
    }
}
