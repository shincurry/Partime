//
//  EditingTextViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/4/25.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class EditingTextViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        editTextField.becomeFirstResponder()
    }
    
    var superLabel: UILabel?
    
    var name: String?
    var detailsName: String?
    
    @IBOutlet weak var editNameLabel: UILabel!
    @IBOutlet weak var editTextField: UITextField!
    
    func setData() {
        if let name = self.name {
            editNameLabel.text = name
        }
        if let detail = detailsName {
            editTextField.text = detail
        }
    }
    @IBAction func editingEnd(sender: UITextField) {
        if let lebel = superLabel {
            lebel.text = editTextField.text
        }
    }
}