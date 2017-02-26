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

    @IBAction func editingEnd(_ sender: UITextField) {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        superLabel.text = editTextField.text! + "元/" + salaryType[selectedRow]
        superController.salary = Int(editTextField.text!)
        superController.salaryTypeCode = selectedRow+14
    }
    
}

extension PublishSalaryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return salaryType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return salaryType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        superLabel.text = editTextField.text! + "元/" + salaryType[row]
        superController.salary = Int(editTextField.text!)
        superController.salaryTypeCode = row+14
    }
}
