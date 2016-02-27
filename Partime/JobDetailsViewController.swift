//
//  JobDetailsViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/1/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import Spring

class JobDetailsViewController: UIViewController {
    var id: Int?
    var isFaved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favButton.tintColor = isFaved ? UIColor(red: 1.000, green: 0.318, blue: 0.333, alpha: 1.00) : UIColor.grayColor()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var favButton: SpringButton!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // 图片？
    // 简要信息
    // 详情
    // 具体时间
    // 工作内容
    // 联系方式、地址
    //
    
    @IBAction func favButtonClicked(sender: UIButton) {
        favButton.animation = "pop"
        isFaved = !isFaved
        if isFaved {
            favButton.tintColor = UIColor(red: 1.000, green: 0.318, blue: 0.333, alpha: 1.00)
            favButton.force = 2.2
            favButton.duration = 0.8
            favButton.animate()
        } else {
            favButton.tintColor = UIColor.grayColor()
            favButton.animation = "pop"
            favButton.force = 1
            favButton.duration = 1.2
            favButton.animate()
        }
    }

}
