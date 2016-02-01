//
//  EditProfileTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/2/1.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

enum EditViewSelection: Int {
    case Nickname = 0
    case Gender = 2
    case Birthday = 4
    case None
    
    static func caseAt(indexPath: NSIndexPath) -> EditViewSelection {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                return .Nickname
            case 2:
                return .Gender
            case 4:
                return .Birthday
            default:
                break
            }
        }
        return .None
    }
}


class EditProfileTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-M-d"
    }
    
    override func viewWillAppear(animated: Bool) {
        if let selection = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selection, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let defaultIsHidden = [[false], [false, true, false, true, false, true, false], [false, false]]
    var currentIsHidden: [[Bool]]?
    
    // MARK: - Nickname Properties
    var isNicknameTextFieldHidden = true
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    
    
    // MARK: - Gender Picker Properties
    let gender = ["Male", "Female"]
    var isGenderPickerHidden = true
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderPicker: UIPickerView!
    
    
    
    
    // MARK: - Date Picker Properties
    var isDatePickerHidden = true

    var dateFormatter = NSDateFormatter()
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        dateLabel.text = dateFormatter.stringFromDate(datePicker.date)
    }
}

// MARK: - Table View Delegate
extension EditProfileTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentIsHidden = defaultIsHidden
        
        switch (indexPath.section, indexPath.row) {
        // Nickname Cell
        case (1, 0):
            isNicknameTextFieldHidden = !isNicknameTextFieldHidden
            if isNicknameTextFieldHidden {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
        // Gender Cell
        case (1, 2):
            isGenderPickerHidden = !isGenderPickerHidden
            if isGenderPickerHidden {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        // Birthday Cell
        case (1, 4):
            isDatePickerHidden = !isDatePickerHidden
            
            if isDatePickerHidden {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        default:
            break
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        
        switch (indexPath.section, indexPath.row) {
        // Nickname Cell
        case (1, 1):
//            nicknameTextField.hidden = isNicknameTextFieldHidden
            if isNicknameTextFieldHidden {
                nicknameTextField.resignFirstResponder()
                return 0
            } else {
                nicknameTextField.text = nicknameLabel.text
                nicknameTextField.becomeFirstResponder()
            }
        // Gender Cell
        case (1, 3):
            genderPicker.hidden = isGenderPickerHidden
            if isGenderPickerHidden {
                return 0
            } else {
                let selectedRow = (genderLabel.text == "Male" ? 0 : 1)
                genderPicker.selectRow(selectedRow, inComponent: 0, animated: true)
            }
        // Birthday Cell
        case (1, 5):
            datePicker.hidden = isDatePickerHidden
            if isDatePickerHidden {
                return 0
            } else {
                datePicker.date = dateFormatter.dateFromString(dateLabel.text!)!
            }
        default:
            break
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
}

// MARK: - Gender Picker Delegate and Datasource
extension EditProfileTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderLabel.text = gender[row]
    }
}

