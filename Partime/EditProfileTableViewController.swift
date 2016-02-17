//
//  EditProfileTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/2/1.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit


enum SelectionStatus {
    case SelectSelf
    case SelectOther
    case SelectNone
}

/**
 *  Table View Edit View Cell 
 *  isShow Data Struct
 */
struct EditViewControl {
    // (是否可以展开编辑 Cell, 是否隐藏)
    private let defaultHiddenStatus = [[(true, false), (false, true)], [(true, false), (false, true), (true, false), (false, true), (true, false), (false, true), (true, false), (false, true)], [(false, false), (false, false)]]
    
    var currentHiddenStatus: [[(Bool, Bool)]]
    init() {
        currentHiddenStatus = defaultHiddenStatus
    }
    
    mutating func selectionAt(indexPath: NSIndexPath) -> SelectionStatus {
        guard currentHiddenStatus[indexPath.section][indexPath.row].0 else {
            return .SelectNone
        }
        
        guard currentHiddenStatus[indexPath.section][indexPath.row+1].1 else {
            currentHiddenStatus[indexPath.section][indexPath.row+1].1 = true
            return .SelectSelf
        }

        currentHiddenStatus = defaultHiddenStatus
        currentHiddenStatus[indexPath.section][indexPath.row+1].1 = false
        return .SelectOther
        
    }
    
}


class EditProfileTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1.00)
        dateFormatter.dateFormat = "yyyy-M-d"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let selection = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selection, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var editControl = EditViewControl()
    
    // MARK: - Nickname Properties
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!

    
    
    // MARK: - Gender Picker Properties
    let gender = ["Male", "Female"]
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderPicker: UIPickerView!

    
    // MARK: - Date Picker Properties
    var dateFormatter = NSDateFormatter()
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        dateLabel.text = dateFormatter.stringFromDate(datePicker.date)
    }
    
    
    var location: Array<String>?
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationPicker: UIPickerView!
    
    
    
    @IBOutlet weak var introduceText: UITextView!
    @IBOutlet weak var restOfCharactersCount: UILabel!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
}

// MARK: - Table View Delegate
extension EditProfileTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let status = editControl.selectionAt(indexPath)
        if status == .SelectNone {
            return
        }
        if status == .SelectSelf {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let isHidden = editControl.currentHiddenStatus[indexPath.section][indexPath.row].1
        
        switch (indexPath.section, indexPath.row) {
        // Avatar Cell
        case (0, 1):
            break
            
        // Nickname Cell
        case (1, 1):
            if isHidden {
                nicknameTextField.resignFirstResponder()
            } else {
                nicknameTextField.text = nicknameLabel.text
                nicknameTextField.becomeFirstResponder()
            }
        // Gender Cell
        case (1, 3):
            genderPicker.hidden = isHidden
            if isHidden {
                let selectedRow = (genderLabel.text == "Male" ? 0 : 1)
                genderPicker.selectRow(selectedRow, inComponent: 0, animated: true)
            }
        // Birthday Cell
        case (1, 5):
            datePicker.hidden = isHidden
            if isHidden {
                datePicker.date = dateFormatter.dateFromString(dateLabel.text!)!
            }
        default:
            break
        }
        if isHidden {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
}

// MARK: - Gender Picker Delegate and Datasource
extension EditProfileTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch pickerView {
        case genderPicker:
            return 1
        case locationPicker:
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case genderPicker:
            return gender.count
        case locationPicker:
            return Location.location.count
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case genderPicker:
            return gender[row]
        case locationPicker:
            return Location.location[row]
        default:
            return ""
        }
        
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case genderPicker:
            genderLabel.text = gender[row]
        case locationPicker:
            locationLabel.text = Location.location[row]
        default:
            break
        }
        
    }

}

// MARK: - Nickname TextField Delegate
extension EditProfileTableViewController {
    @IBAction func editingChanged(sender: UITextField) {
        nicknameLabel.text = nicknameTextField.text
        // 当清空输入框重新输入文本的时候需要重新 Layout Label
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) {
            cell.layoutSubviews()
        }
    }
}


extension EditProfileTableViewController {
    
    @IBAction func selectPhoto(sender: UIButton) {
        print("selectPhoto")
    }
    @IBAction func takePhoto(sender: UIButton) {
        print("takePhoto")
    }
    
}

extension EditProfileTableViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        let length = textView.text.characters.count
        if length > 140 {
            restOfCharactersCount.textColor = UIColor.redColor()
            saveButton.enabled = false
        } else {
            restOfCharactersCount.textColor = UIColor.lightGrayColor()
            saveButton.enabled = true
        }
        restOfCharactersCount.text = String(140 - length)
    }
}
