//
//  DatePickerViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/4/25.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        datePickerView.maximumDate = NSDate()
    }
    var dateFormatter = NSDateFormatter()
    var superLabel: UILabel?
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        superLabel?.text = dateFormatter.stringFromDate(datePickerView.date)
    }
}
