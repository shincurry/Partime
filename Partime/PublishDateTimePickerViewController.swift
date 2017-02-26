//
//  PublishDateTimePickerViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/5/5.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

enum DateTimePickerType {
    case dateFrom
    case dateTo
    case timeFrom
    case timeTo
    case none
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
    
    var type: DateTimePickerType = .none
    
    var dateFormatter = DateFormatter()
    var superLabel: UILabel!
    @IBOutlet weak var pickerView: UIDatePicker!
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        setLabel()
    }
    
    fileprivate func initPicker() {
        switch type {
        case .dateFrom:
            fallthrough
        case .dateTo:
            pickerView.datePickerMode = .date
            dateFormatter.dateFormat = "yyyy-MM-dd"
            pickerView.minimumDate = Date()
        case .timeFrom:
            fallthrough
        case .timeTo:
            pickerView.datePickerMode = .time
            dateFormatter.dateFormat = "HH:mm"
        default:
            break
        }
    }
    
    fileprivate func setLabel() {
        superLabel.text = dateFormatter.string(from: pickerView.date)
    }

}
