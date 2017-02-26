//
//  HomeNavigatorCollectionViewCell.swift
//  Partime
//
//  Created by ShinCurry on 16/2/15.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class HalfHomeNavigatorCollectionViewCell: UICollectionViewCell {
    
    override func didAddSubview(_ subview: UIView) {
        backgroundColor = UIColor.white
    }
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
}
