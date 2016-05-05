//
//  PublishDateTimePickerViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/5/5.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

enum DateTimePickerType {
    case DateFrom
    case DateTo
    case TimeFrom
    case TimeTo
    case None
}

class PublishDateTimePickerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initPicker()
        setLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var type: DateTimePickerType = .None
    
    var dateFormatter = NSDateFormatter()
    var superLabel: UILabel!
    @IBOutlet weak var pickerView: UIDatePicker!
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        setLabel()
    }
    
    private func initPicker() {
        switch type {
        case .DateFrom:
            fallthrough
            
        case .DateTo:
            pickerView.datePickerMode = .Date
            dateFormatter.dateFormat = "yyyy-MM-dd"
        case .TimeFrom:
            fallthrough
        case .TimeTo:
            pickerView.datePickerMode = .Time
            dateFormatter.dateFormat = "HH:mm"
        default:
            break
        }
    }
    
    private func setLabel() {
        superLabel.text = dateFormatter.stringFromDate(pickerView.date)
    }

}
