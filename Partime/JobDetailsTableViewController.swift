//
//  JobDetailsTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/2/27.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class JobDetailsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tempData()
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
    
    @IBOutlet weak var companyLogoImage: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var contactQQImage: UIImageView!
    @IBOutlet weak var contactTelephoneImage: UIImageView!
    @IBOutlet weak var contactMailImage: UIImageView!
    
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var mapLabel: UILabel!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Table View Delegate and DataSource
extension JobDetailsTableViewController {
    func tempData() {
        navigatorTitle.title = "某不知名兼职工作"
        titleLabel.text = "某不知名兼职工作"
        locationLabel.text = "重庆理工大学"
        timeLabel.text = "2016-1-1"
        rateLabel.text = RateStar(score: 4).getStars()
        jobDetailsText.text = "背书:\n我一再翻阅这些痛苦的回忆，一面不断地自问，是否在那个阳光灿烂的遥远的夏天，我生活中发狂的预兆已经开始，还是我对那个孩子的过度欲望，只是一种与生俱来的怪癖的最早迹象呢？在我努力分析自己的渴望、动机和行为等等的时候，我总陷入一种追忆往事的幻想，这种幻想为分析官能提供了无限的选择，并且促使想象中的每一条线路在我过去那片复杂得令人发疯的境界中漫无止境地一再往外分岔。可是，我深信，从某种魔法和宿命的观点而言，洛丽塔是从安娜贝尔开始的。\n我一再翻阅这些痛苦的回忆，一面不断地自问，是否在那个阳光灿烂的遥远的夏天，我生活中发狂的预兆已经开始，还是我对那个孩子的过度欲望，只是一种与生俱来的怪癖的最早迹象呢？在我努力分析自己的渴望、动机和行为等等的时候，我总陷入一种追忆往事的幻想，这种幻想为分析官能提供了无限的选择，并且促使想象中的每一条线路在我过去那片复杂得令人发疯的境界中漫无止境地一再往外分岔。可是，我深信，从某种魔法和宿命的观点而言，洛丽塔是从安娜贝尔开始的。"
        
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
        contactMailImage.tintColor = Theme.mainColor
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
