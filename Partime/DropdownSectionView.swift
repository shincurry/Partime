//
//  DropdownHeaderView.swift
//  Partime
//
//  Created by ShinCurry on 16/3/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import Foundation
import UIKit


class DropdownSectionView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubView()
    }
    
    var view: UIView!
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var horizonSeparator: UIView!
    
//    var themeColor: UIColor!
    
    var highlighted = false {
        didSet {
            if highlighted {
                headerButton.setTitleColor(tintColor, forState: .Normal)
                headerImage.tintColor = tintColor
                horizonSeparator.backgroundColor = tintColor
                UIView.animateWithDuration(0.4, animations: {
                    self.headerImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                })
            } else {
                headerButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
                headerImage.tintColor = UIColor.lightGrayColor()
                horizonSeparator.backgroundColor = UIColor.lightGrayColor()
                UIView.animateWithDuration(0.44, animations: {
                    self.headerImage.transform = CGAffineTransformMakeRotation(0)
                })
            }
            
            
        }
    }
    
    
    
    func loadViewFfromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func initSubView() {
        view = loadViewFfromNib()
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        view.frame = bounds
        addSubview(view)
        
//        themeColor = UIColor.blueColor()
    }
}
