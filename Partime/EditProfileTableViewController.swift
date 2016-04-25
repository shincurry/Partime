//
//  EditProfileTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/2/1.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import SwiftyJSON


class EditProfileTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Theme.backgroundColor
        dateFormatter.dateFormat = "yyyy-M-d"
        takePhotoButton.setTitleColor(Theme.mainColor, forState: .Normal)
        selectPhotoButton.setTitleColor(Theme.mainColor, forState: .Normal)
        
        getProfileInfo()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    var editControl = EditViewControl()
    
    // MARK: - Nickname Properties
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!

    let defaults = NSUserDefaults.standardUserDefaults()
    let api = API.shared
    // MARK: - Gender Picker Properties
    let gender = [NSLocalizedString("male", comment: ""), NSLocalizedString("female", comment: "")]
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderPicker: UIPickerView!

    
    // MARK: - Date Picker Properties
    var dateFormatter = NSDateFormatter()
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        dateLabel.text = dateFormatter.stringFromDate(datePicker.date)
    }
    
    
    // MARK: - Location Picker Properties
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationPicker: UIPickerView!
    

    // MARK: - Introduce Text Properties
    @IBOutlet weak var introduceText: UITextView!
    @IBOutlet weak var restOfCharactersCount: UILabel!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    func getProfileInfo() {
        nicknameLabel.text = defaults.objectForKey("ProfileRealname") as? String
        genderLabel.text = defaults.objectForKey("ProfileGender") as? String
        introduceText.text = defaults.objectForKey("ProfileTellUs") as! String
    }
    func setProfileInfo() {
        print(nicknameLabel.text)
        defaults.setObject(nicknameLabel.text, forKey: "ProfileRealname")
        defaults.setObject(genderLabel.text, forKey: "ProfileGender")
        defaults.setObject(introduceText.text, forKey: "ProfileTellUs")

    }
    
    @IBAction func saveProfile(sender: UIBarButtonItem) {
        setProfileInfo()
        print(API.token!)
        let params: [String: String] = ["access_token": API.token!,
                      "email": defaults.objectForKey("ProfileEmail") as! String,
                      "username": defaults.objectForKey("ProfileUsername") as! String,
                      "realname": defaults.objectForKey("ProfileRealname") as! String,
                      "gender": defaults.objectForKey("ProfileGender") as! String,
                      "birthday": defaults.objectForKey("ProfileUsername") as! String,
                      "inschoolid": defaults.objectForKey("ProfileInSchoolID") as! String,
                      "school": defaults.objectForKey("ProfileSchool") as! String,
                      
                      "major": defaults.objectForKey("ProfileUsername") as! String,
                      "theyear": "",
                      "tellus": defaults.objectForKey("ProfileTellUs") as! String,
                      "bookpttypeids": "",
                      "wechatid": defaults.objectForKey("ProfileWechatID") as! String,
        ]
        
        api.updateProfile(params) { result in
            switch result {
            case .Success:
                print("updateEmployeeProfile")
                print(result.value!)
                print(JSON(data: result.value!).stringValue)
                self.performSegueWithIdentifier("UnwindEditToProfileTableViewController", sender: self)
            case .Failure(let error):
                print(error)
            }
            
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "UnwindEditToProfileTableViewController":
                let controller = segue.destinationViewController as! ProfileTableViewController
                controller.updateLoginStatus()
            default:
                break
            }
        }
    }
    
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

// MARK: - Picker Delegate and Datasource
extension EditProfileTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch pickerView {
        case genderPicker:
            return 1
        case locationPicker:
            return 3
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case genderPicker:
            return gender.count
        case locationPicker:
            let selectInComponent0 = locationPicker.selectedRowInComponent(0)
            
            
            let provinces = Location.allPlaces.array!
            if component == 0 {
                return provinces.count
            }
            let cities = provinces[selectInComponent0]["sub"].array!
            let selectInComponent1 = locationPicker.selectedRowInComponent(1)
            if component == 1 {
                return cities.count
            }
            
            
            let counties = cities[selectInComponent1]["sub"].array!
            return counties.count

        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case genderPicker:
            return gender[row]
        case locationPicker:
            let selectInComponent0 = locationPicker.selectedRowInComponent(0)
            
            let province = Location.allPlaces.array!
            if component == 0 {
                return province[row]["value"]["name"].stringValue
            }
            let selectInComponent1 = locationPicker.selectedRowInComponent(1)
            let city = province[selectInComponent0]["sub"].array!
            if component == 1 {
                return city[row]["value"]["name"].stringValue
            }
//            let selectInComponent2 = locationPicker.selectedRowInComponent(2)
            let county = city[selectInComponent1]["sub"].array!
            return county[row]["name"].stringValue
        default:
            return ""
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case genderPicker:
            genderLabel.text = gender[row]
        case locationPicker:
            let selectInComponent0 = locationPicker.selectedRowInComponent(0)
            let selectInComponent1 = locationPicker.selectedRowInComponent(1)
            let selectInComponent2 = locationPicker.selectedRowInComponent(2)
            if component == 0 {
                locationPicker.selectRow(0, inComponent: 1, animated: true)
                locationPicker.reloadComponent(1)
                /**
                * selectRow(row: Int, inComponent: Int, animated: Bool) 需要手动调用
                * pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
                */
                self.pickerView(locationPicker, didSelectRow: 0, inComponent: 1)
            } else if component == 1 {
                locationPicker.selectRow(0, inComponent: 2, animated: true)
                locationPicker.reloadComponent(2)
                self.pickerView(locationPicker, didSelectRow: 0, inComponent: 2)
            } else {
                let province = Location.allPlaces.array![selectInComponent0]
                let city = province["sub"].array![selectInComponent1]
                let county = city["sub"].array![selectInComponent2]
                
                locationLabel.text = "\(province["value"]["name"].stringValue) \(city["value"]["name"].stringValue) \(county["name"].stringValue)"
            }
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
