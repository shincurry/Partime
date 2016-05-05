//
//  PublishEditingTextViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/5/3.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit



class PublishEditingTextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        editTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var superLabel: UILabel!
    
    var name: String!
    var detailsName: String!
    
    @IBOutlet weak var editNameLabel: UILabel!
    @IBOutlet weak var editTextField: UITextField!
    
    func initView() {
        switch name {
        case "工资待遇":
            fallthrough
        case "招聘人数":
            editTextField.keyboardType = .NumberPad
        case "联系电话":
            editTextField.keyboardType = .PhonePad
        default:
            break
        }
        
        if name.characters.last == "*" {
            let text = name.componentsSeparatedByString(" ")[0]
            editNameLabel.text = text
            self.navigationItem.title = "修改" + text
        } else {
            editNameLabel.text = name
            self.navigationItem.title = "修改" + name
        }
        editTextField.text = detailsName
    }
    @IBAction func editingEnd(sender: UITextField) {
        superLabel.text = editTextField.text
    }
}
