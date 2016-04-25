//
//  MyJobsTableViewCell.swift
//  Partime
//
//  Created by ShinCurry on 16/4/18.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class MyJobsTableViewCell: UITableViewCell {
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
    
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var salaryImage: UIImageView!
    @IBOutlet weak var salaryLabel: UILabel!
}

extension MyJobsTableViewCell {
    private func initialStyle() {
        timeImage.tintColor = Theme.mainColor
        salaryImage.tintColor = Theme.mainColor
        
        logoImage.clipsToBounds = true
        logoImage.layer.cornerRadius = logoImage.frame.size.width / 2
        separatorInset.left = 8 + logoImage.frame.size.width + 8
    }
    
}
