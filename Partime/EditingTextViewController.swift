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
        if self.name == "身高" {
            editTextField.keyboardType = .NumberPad
        } else if self.name == "性别" {
            superLabel?.text = "男"
        }
        
        
        if let name = self.name {
            if name.characters.last == "*" {
                let text = name.componentsSeparatedByString(" ")[0]
                editNameLabel.text = text
                self.navigationItem.title = "修改" + text
            } else {
                editNameLabel.text = name
                self.navigationItem.title = "修改" + name
            }
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