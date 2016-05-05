//
//  JobDetailsTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/2/27.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import MJRefresh

class JobDetailsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = API.token {
        } else {
            joinButton.enabled = false
        }
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var jobTypeLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var genderRequireLabel: UILabel!
    
    
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateScoreLabel: UILabel!
    
    
    @IBOutlet weak var workRequireTextView: UITextView!
    @IBOutlet weak var workContentTextView: UITextView!
    
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
            loadData()
        }
    }
    var location: (Double, Double)?
    var mapHidden = true
    
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
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        switch identifier {
            case "ShowMapSegue":
                if let _ = location {
                    return true
                }
            default:
                break
            }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            
            switch identifier {
            case "ShowMapSegue":
                let controller = segue.destinationViewController as! MapViewController
                controller.location = location
                
            default:
                break
            }
            
        }
    }
    
}

// MARK: - Table View Delegate and DataSource
extension JobDetailsTableViewController {
    func loadData() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        api.getJobDetails(id!) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                print(res)
                if res["status"] == "success" {
                    print(res["result"])
                    self.setInfo(res["result"])
                } else if res["status"] == "failure" {
                    print("failure")
                }
            case .Failure(let error):
                print(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tableView.mj_header.endRefreshing()
        }
        
    }
    
    func setInfo(data: JSON) {
        navigatorTitle.title = data["title"].stringValue
        titleLabel.text = data["title"].stringValue
        
        
        locationLabel.text = data["district"].stringValue
        timeLabel.text = data["dateBegin"].stringValue
        
        
        rateLabel.text = RateStar(score: 0).getStars()
        rateScoreLabel.text = "0"
        
        
        jobTypeLabel.text = data["type"].stringValue
        memberCountLabel.text = "\(data["amount"].intValue)"
        salaryLabel.text = data["salary"].stringValue + "元"
        genderRequireLabel.text = data["genderneed"].stringValue
        
        
        
        workDateLabel.text = "\(data["dateBegin"].stringValue) ~ \(data["dateEnd"].stringValue)"
        workTimeLabel.text = data["timeBegin"].stringValue + " ~ " + data["timeEnd"].stringValue
        
        
        workContentTextView.text = data["institution"].stringValue
        
        
        contactTelephoneButton.titleLabel!.text = data["contactphone"].stringValue
        
        if let address = data["address"].string {
            mapLabel.text = address
            if let latitude = data["latitude"].double {
                if let longitude = data["longitude"].double {
                    location = (latitude, longitude)
                    mapHidden = false
                }
            }
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
        if indexPath.section == 1 && indexPath.row == 2 {
            let originalHeight = workContentTextView.frame.height
            let fullHeight = workContentTextView.fullSize().height
            cellHeight += fullHeight - originalHeight
        } else if indexPath.section == 4 && indexPath.row == 1 {
            if mapHidden {
                cellHeight = 0
            }
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
