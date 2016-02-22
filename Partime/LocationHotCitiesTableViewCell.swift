//
//  LocationHotCitiesTableViewCell.swift
//  Partime
//
//  Created by ShinCurry on 16/2/20.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class LocationHotCitiesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialHotCitiesCollection()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var hotCitiesCollection: UICollectionView!
}

/// MARK: - Location Hot Cities Collection Delegate and DataSource
extension LocationHotCitiesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func initialHotCitiesCollection() {
//        hotCitiesCollection.backgroundColor = UIColor.whiteColor()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Location.hotCities.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HotCitiesCollectionCell", forIndexPath: indexPath) as! LocationHotCitiesCollectionViewCell
        cell.hotCityButton.setTitle(Location.hotCities[indexPath.row], forState: .Normal)
        cell.clipsToBounds = true
        cell.layer.cornerRadius = cell.frame.size.width / 10.0
        cell.layer.borderWidth = 0.3
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellHeight = CGFloat(32)
        let cellWidth = collectionView.frame.width / 3.0 - 8.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
}