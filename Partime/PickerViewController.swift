//
//  PickerViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/4/25.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

enum PickerType {
    case gender
    case location
}

class PickerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        switch type {
        case .some(.gender):
            navigationItem.title = "选择性别"
        case .some(.location):
            navigationItem.title = "选择位置"
        default:
            break
        }
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    var superController: EditingProfileTableViewController!
    var superLabel: UILabel!
    
    var type: PickerType!
    var gender = ["男", "女"]
    var value = ""
}

// MARK: - Picker Delegate and Datasource
extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch type {
        case .some(.gender):
            return 1
        case .some(.location):
            return 3
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type {
        case .some(.gender):
            return 2
        case .some(.location):
            let selectInComponent0 = pickerView.selectedRow(inComponent: 0)
            
            let provinces = Location.allPlaces.array!
            if component == 0 {
                return provinces.count
            }
            let cities = provinces[selectInComponent0]["sub"].array!
            let selectInComponent1 = pickerView.selectedRow(inComponent: 1)
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
        switch type {
        case .some(.gender):
            return gender[row]
        case .some(.location):
            let selectInComponent0 = pickerView.selectedRow(inComponent: 0)
            
            let province = Location.allPlaces.array!
            if component == 0 {
                return province[row]["value"]["name"].stringValue
            }
            let selectInComponent1 = pickerView.selectedRow(inComponent: 1)
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
        switch type {
        case .some(.gender):
            superLabel.text = gender[row]
        case .some(.location):
            let selectInComponent0 = pickerView.selectedRow(inComponent: 0)
            let selectInComponent1 = pickerView.selectedRow(inComponent: 1)
            let selectInComponent2 = pickerView.selectedRow(inComponent: 2)
            if component == 0 {
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
                /**
                 * selectRow(row: Int, inComponent: Int, animated: Bool) 需要手动调用
                 * pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
                 */
                self.pickerView(pickerView, didSelectRow: 0, inComponent: 1)
            } else if component == 1 {
                pickerView.selectRow(0, inComponent: 2, animated: true)
                pickerView.reloadComponent(2)
                self.pickerView(pickerView, didSelectRow: 0, inComponent: 2)
            } else {
                let province = Location.allPlaces.array![selectInComponent0]
                let city = province["sub"].array![selectInComponent1]
                let county = city["sub"].array![selectInComponent2]
                
                superLabel.text = "\(city["value"]["name"].stringValue) \(county["name"].stringValue)"
                superController.provinceCode = province["code"].stringValue
                superController.cityCode = city["code"].stringValue
                superController.districtCode = county["code"].stringValue
            }
        default:
            break
        }
        
    }
}
