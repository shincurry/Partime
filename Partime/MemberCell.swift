//
//  MemberCell.swift
//  Partime
//
//  Created by ShinCurry on 16/5/23.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code 
        initialStyle()
    }
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusColorView: UIView!
}

extension MemberCell {
    private func initialStyle() {
        imgView.tintColor = Theme.mainColor
        
        statusLabel.textColor = Theme.mainColor
        
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = imgView.frame.size.width / 2
        separatorInset.left = 8 + imgView.frame.size.width + 8
    }
    
}