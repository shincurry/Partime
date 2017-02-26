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
    @IBOutlet weak var alertMessageLabel: UILabel!
    
    func initView() {
        switch name {
        case "招聘人数":
            editTextField.keyboardType = .numberPad
            alertMessageLabel.text = "请输入数字"
        case "联系电话 *":
            editTextField.keyboardType = .phonePad
            alertMessageLabel.text = "请输入11位的电话号码"
        default:
            break
        }

        
        if name.characters.last == "*" {
            let text = name.components(separatedBy: " ")[0]
            editNameLabel.text = text
            navigationItem.title = "修改" + text
        } else {
            editNameLabel.text = name
            navigationItem.title = "修改" + name
        }
        
        editTextField.text = detailsName
    }
    @IBAction func editingEnd(_ sender: UITextField) {
        superLabel.text = editTextField.text
    }
}
