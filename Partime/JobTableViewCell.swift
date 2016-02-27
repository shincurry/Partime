//
//  JobsTableViewCell.swift
//  Partime
//
//  Created by ShinCurry on 16/1/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialStyle()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - View Properties
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var salaryImage: UIImageView!
    @IBOutlet weak var salaryLabel: UILabel!
}

extension JobTableViewCell {
    private func initialStyle() {
//        locationImage.tintColor = UIColor.darkGrayColor()
//        timeImage.tintColor = UIColor.darkGrayColor()
//        salaryImage.tintColor = UIColor.darkGrayColor()
//        let color = UIColor(red: 147/255.0, green: 44/255.0, blue: 48/255.0, alpha: 1)
        locationImage.tintColor = Theme.mainColor
        timeImage.tintColor = Theme.mainColor
        salaryImage.tintColor = Theme.mainColor
        
        logoImage.clipsToBounds = true
        logoImage.layer.cornerRadius = logoImage.frame.size.width / 2
    }

}
