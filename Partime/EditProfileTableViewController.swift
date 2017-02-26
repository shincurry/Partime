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
        takePhotoButton.setTitleColor(Theme.mainColor, for: UIControlState())
        selectPhotoButton.setTitleColor(Theme.mainColor, for: UIControlState())
        
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

    let defaults = UserDefaults.standard
    let api = API.shared
    // MARK: - Gender Picker Properties
    let gender = [NSLocalizedString("male", comment: ""), NSLocalizedString("female", comment: "")]
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderPicker: UIPickerView!

    
    // MARK: - Date Picker Properties
    var dateFormatter = DateFormatter()
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        dateLabel.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    // MARK: - Location Picker Properties
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationPicker: UIPickerView!
    

    // MARK: - Introduce Text Properties
    @IBOutlet weak var introduceText: UITextView!
    @IBOutlet weak var restOfCharactersCount: UILabel!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    func getProfileInfo() {
        nicknameLabel.text = defaults.object(forKey: "ProfileRealname") as? String
        genderLabel.text = defaults.object(forKey: "ProfileGender") as? String
        introduceText.text = defaults.object(forKey: "ProfileTellUs") as! String
    }
    func setProfileInfo() {
        print(nicknameLabel.text ?? "")
        defaults.set(nicknameLabel.text, forKey: "ProfileRealname")
        defaults.set(genderLabel.text, forKey: "ProfileGender")
        defaults.set(introduceText.text, forKey: "ProfileTellUs")

    }
    
    @IBAction func saveProfile(_ sender: UIBarButtonItem) {
        setProfileInfo()
        print(API.token!)
        let params: [String: String] = ["access_token": API.token!,
                      "email": defaults.object(forKey: "ProfileEmail") as! String,
                      "username": defaults.object(forKey: "ProfileUsername") as! String,
                      "realname": defaults.object(forKey: "ProfileRealname") as! String,
                      "gender": defaults.object(forKey: "ProfileGender") as! String,
                      "birthday": defaults.object(forKey: "ProfileUsername") as! String,
                      "inschoolid": defaults.object(forKey: "ProfileInSchoolID") as! String,
                      "school": defaults.object(forKey: "ProfileSchool") as! String,
                      
                      "major": defaults.object(forKey: "ProfileUsername") as! String,
                      "theyear": "",
                      "tellus": defaults.object(forKey: "ProfileTellUs") as! String,
                      "bookpttypeids": "",
                      "wechatid": defaults.object(forKey: "ProfileWechatID") as! String,
        ]
        
        api.updateProfile(params as [String : AnyObject]) { result in
            switch result {
            case .success:
                print("updateEmployeeProfile")
                print(result.value!)
                print(JSON(data: result.value!).stringValue)
                self.performSegue(withIdentifier: "UnwindEditToProfileTableViewController", sender: self)
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "UnwindEditToProfileTableViewController":
                let controller = segue.destination as! ProfileTableViewController
                controller.updateLoginStatus()
            default:
                break
            }
        }
    }
    
}

// MARK: - Table View Delegate
extension EditProfileTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let status = editControl.selectionAt(indexPath)
        if status == .selectNone {
            return
        }
        if status == .selectSelf {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
            genderPicker.isHidden = isHidden
            if isHidden {
                let selectedRow = (genderLabel.text == "Male" ? 0 : 1)
                genderPicker.selectRow(selectedRow, inComponent: 0, animated: true)
            }
        // Birthday Cell
        case (1, 5):
            datePicker.isHidden = isHidden
            if isHidden {
                datePicker.date = dateFormatter.date(from: dateLabel.text!)!
            }
        default:
            break
        }
        if isHidden {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
}

// MARK: - Picker Delegate and Datasource
extension EditProfileTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case genderPicker:
            return 1
        case locationPicker:
            return 3
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case genderPicker:
            return gender.count
        case locationPicker:
            let selectInComponent0 = locationPicker.selectedRow(inComponent: 0)
            
            
            let provinces = Location.allPlaces.array!
            if component == 0 {
                return provinces.count
            }
            let cities = provinces[selectInComponent0]["sub"].array!
            let selectInComponent1 = locationPicker.selectedRow(inComponent: 1)
            if component == 1 {
                return cities.count
            }
            
            
            let counties = cities[selectInComponent1]["sub"].array!
            return counties.count

        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case genderPicker:
            return gender[row]
        case locationPicker:
            let selectInComponent0 = locationPicker.selectedRow(inComponent: 0)
            
            let province = Location.allPlaces.array!
            if component == 0 {
                return province[row]["value"]["name"].stringValue
            }
            let selectInComponent1 = locationPicker.selectedRow(inComponent: 1)
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case genderPicker:
            genderLabel.text = gender[row]
        case locationPicker:
            let selectInComponent0 = locationPicker.selectedRow(inComponent: 0)
            let selectInComponent1 = locationPicker.selectedRow(inComponent: 1)
            let selectInComponent2 = locationPicker.selectedRow(inComponent: 2)
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
    @IBAction func editingChanged(_ sender: UITextField) {
        nicknameLabel.text = nicknameTextField.text
        // 当清空输入框重新输入文本的时候需要重新 Layout Label
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) {
            cell.layoutSubviews()
        }
    }
}


extension EditProfileTableViewController {
    
    @IBAction func selectPhoto(_ sender: UIButton) {
        print("selectPhoto")
    }
    @IBAction func takePhoto(_ sender: UIButton) {
        print("takePhoto")
    }
    
}

extension EditProfileTableViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let length = textView.text.characters.count
        if length > 140 {
            restOfCharactersCount.textColor = UIColor.red
            saveButton.isEnabled = false
        } else {
            restOfCharactersCount.textColor = UIColor.lightGray
            saveButton.isEnabled = true
        }
        restOfCharactersCount.text = String(140 - length)
    }
}
