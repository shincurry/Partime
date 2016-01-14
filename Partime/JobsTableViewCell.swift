//
//  JobsTableViewCell.swift
//  Partime
//
//  Created by ShinCurry on 16/1/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class JobsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialization(index row: Int , title: String, salary: String, time: String, workplace: String) {
        index = row
        jobTitle.text = tempData[index][0]
        jobSalary.text = tempData[index][1]
        jobTime.text = tempData[index][2]
        jobWorkplace.text = tempData[index][3]
        jobImage.image = UIImage(named: "Logo")
        jobImage.clipsToBounds = true
        jobImage.layer.cornerRadius = jobImage.frame.size.width / 2
    
    }
    var index: Int = -1
    @IBOutlet weak var jobImage: UIImageView!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var jobSalary: UILabel!
    @IBOutlet weak var jobTime: UILabel!
    @IBOutlet weak var jobWorkplace: UILabel!
    
    let tempData: [[String]] = [["德克士收银员", "100 元 / 日", "7:00 - 17:00", "重庆"],
                                       ["发传单", "60 元 / 日", "13:00 - 17:00", "重庆理工大学"],
                                       ["Disco cashier", "100 / day", "7:00 - 17:00", "CQ"],
                                       ["德克士收银员", "100 元 / 日", "7:00 - 17:00", "重庆"],
                                       ["发传单", "60 元 / 日", "13:00 - 17:00", "重庆理工大学"],
                                       ["Disco cashier", "100 / day", "7:00 - 17:00", "CQ"],
                                        ["德克士收银员", "100 元 / 日", "7:00 - 17:00", "重庆"],
                                        ["发传单", "60 元 / 日", "13:00 - 17:00", "重庆理工大学"],
                                        ["Disco cashier", "100 / day", "7:00 - 17:00", "CQ"],
                                        ["德克士收银员", "100 元 / 日", "7:00 - 17:00", "重庆"],
                                        ["发传单", "60 元 / 日", "13:00 - 17:00", "重庆理工大学"],
                                        ["Disco cashier", "100 / day", "7:00 - 17:00", "CQ"]]
}
