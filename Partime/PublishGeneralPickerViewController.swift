//
//  PublishGeneralPickerViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/5/5.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import SwiftyJSON

enum GenderalPickerType {
    case genderRequire
    case location
    case jobType
    case paymentType
    case none
}

class PublishGeneralPickerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pickerView.isMultipleTouchEnabled = false
        pickerView.isExclusiveTouch = true
        switch type {
        case .genderRequire:
            navigationItem.title = "选择性别"
            superLabel.text = gender[0].0
            superController.genderRequireCode = 13
        case .location:
            navigationItem.title = "选择位置"
            superLabel.text = "北京市 东城区"
            superController.districtCode = "110101"
            defaultLocation = (Array(repeating: "", count: maxProvince),
                               Array(repeating: "", count: maxCity),
                               Array(repeating: "", count: maxCounty))
            locations = getLocationList(0, 0)
        case .jobType:
            navigationItem.title = "选择职位类型"
            superLabel.text = jobType[0]
            superController.jobTypeCode = 1
        case .paymentType:
            navigationItem.title = "选择结算方式"
            superLabel.text = paymentType[0]
            superController.paymentTypeCode = 19
        default:
            break
        }
    }

    @IBOutlet weak var pickerView: UIPickerView!
    
    let maxProvince = 31
    let maxCity = 21
    let maxCounty = 38
    
    typealias SelectionLocations = (provinces: [String], cities: [String], counties: [String])
    var defaultLocation: SelectionLocations!
    
    var locations: SelectionLocations = ([], [], [])
    
    func getLocationList(_ provinceIndex: Int, _ cityIndex: Int) -> SelectionLocations {
        var tempLocations = defaultLocation
        let provinces = Location.allPlaces.array!
        provinces.enumerated().forEach() { (index, province) in
            tempLocations!.provinces[index] = province["value"]["name"].stringValue
        }
        let cities = provinces[provinceIndex]["sub"].array!
        cities.enumerated().forEach() { (index, city) in
            tempLocations!.cities[index] = city["value"]["name"].stringValue
        }
        let counties = cities[cityIndex]["sub"].array!
        counties.enumerated().forEach() { (index, county) in
            tempLocations!.counties[index] = county["name"].stringValue
        }
        return tempLocations!
    }
    
    
    
    var superController: PublishEditingTableViewController!
    var superLabel: UILabel!
    
    var type: GenderalPickerType = .none
    
    
    // DataSource
    let gender = [("不限", 13), ("男", 11), ("女", 12)]
    let jobType = ["传单派发", "促销导购", "话务客服", "礼仪模特", "老师家教", "服务员", "问卷调查", "审核录入", "地推拉访", "其它"]
    let paymentType = ["日结", "周结", "完工结"]
    
    var value = ""
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

// MARK: - Picker Delegate and Datasource
extension PublishGeneralPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch type {
        case .genderRequire:
            return 1
        case .location:
            return 3
        case .jobType:
            return 1
        case .paymentType:
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type {
        case .genderRequire:
            return gender.count
        case .jobType:
            return jobType.count
        case .paymentType:
            return paymentType.count
        case .location:
//            switch component {
//            case 0:
//                return maxProvince
//            case 1:
//                return maxCity
//            case 2:
//                return maxCounty
//            default:
//                return 0
//            }
            let selectInComponent0 = pickerView.selectedRow(inComponent: 0)
            
            let provinces = Location.allPlaces.array!
            if component == 0 {
                return provinces.count
            }
            let cities = provinces[selectInComponent0]["sub"].array!
            let selectInComponent1 = pickerView.selectedRow(inComponent: 1)
            if component == 1 {
                if maxCity < cities.count {
                }
                return cities.count
            }
            let counties = cities[selectInComponent1]["sub"].array!
            if maxCounty < counties.count {
            }
            return counties.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch type {
        case .genderRequire:
            return gender[row].0
        case .jobType:
            return jobType[row]
        case .paymentType:
            return paymentType[row]
        case .location:
//            let selectInComponent0 = pickerView.selectedRowInComponent(0)
//            let selectInComponent1 = pickerView.selectedRowInComponent(1)
//            let selectInComponent2 = pickerView.selectedRowInComponent(2)
//            
            switch component {
            case 0:
                return locations.provinces[row]
            case 1:
                return locations.cities[row]
            case 2:
                return locations.counties[row]
            default:
                return ""
            }
            
//            let selectInComponent0 = pickerView.selectedRowInComponent(0)
//            
//            let province = Location.allPlaces.array!
//            if component == 0 {
//                return province[row]["value"]["name"].stringValue
//            }
//            let selectInComponent1 = pickerView.selectedRowInComponent(1)
//            let city = province[selectInComponent0]["sub"].array!
//            if component == 1 {
//                return city[row]["value"]["name"].stringValue
//            }
//            let county = city[selectInComponent1]["sub"].array!
//            return county[row]["name"].stringValue
        default:
            return ""
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch type {
        case .genderRequire:
            superLabel.text = gender[row].0
            superController.genderRequireCode = gender[row].1
        case .jobType:
            superLabel.text = jobType[row]
            superController.jobTypeCode = row+1
        case .paymentType:
            superLabel.text = paymentType[row]
            superController.paymentTypeCode = row+19
        case .location:
            let selectInComponent0 = pickerView.selectedRow(inComponent: 0)
            let selectInComponent1 = pickerView.selectedRow(inComponent: 1)
            let selectInComponent2 = pickerView.selectedRow(inComponent: 2)
            
            locations = getLocationList(selectInComponent0, selectInComponent1)

            if component == 0 {
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
                self.pickerView(pickerView, didSelectRow: 0, inComponent: 1)
            } else if component == 1 {
                let citiesCount = locations.cities.filter({return !$0.isEmpty }).count
                if row > citiesCount {
                    return
                }
                pickerView.selectRow(0, inComponent: 2, animated: true)
                pickerView.reloadComponent(2)
                
                
                self.pickerView(pickerView, didSelectRow: 0, inComponent: 2)
                
            } else {
                let countiesCount = locations.counties.filter({return !$0.isEmpty }).count
                if row > countiesCount {
                    return
                }
                
                let province = Location.allPlaces.array![selectInComponent0]
                let city = province["sub"].array![selectInComponent1]
                let district = city["sub"].array![selectInComponent2]
                
                superLabel.text = "\(city["value"]["name"].stringValue) \(district["name"].stringValue)"
                print(superLabel?.text ?? "")
                superController.provinceCode = province["code"].stringValue
                superController.cityCode = city["code"].stringValue
                superController.districtCode = district["code"].stringValue
            }
        default:
            break
        }
    }
    
}
