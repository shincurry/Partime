//
//  PublishSalaryViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/5/5.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class PublishSalaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        editTextField.text = "\(superController.salary!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var superController: PublishEditingTableViewController!
    var superLabel: UILabel!
    
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let salaryType = ["天", "小时", "次", "个", "件"]

    @IBAction func editingEnd(sender: UITextField) {
        let selectedRow = pickerView.selectedRowInComponent(0)
        superLabel.text = editTextField.text! + "元/" + salaryType[selectedRow]
        superController.salary = Int(editTextField.text!)
        superController.salaryTypeCode = selectedRow+14
    }
    
}

extension PublishSalaryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return salaryType.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return salaryType[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        superLabel.text = editTextField.text! + "元/" + salaryType[row]
        superController.salary = Int(editTextField.text!)
        superController.salaryTypeCode = row+14
    }
}