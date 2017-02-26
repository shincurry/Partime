//
//  EnterpriseVerificationTableViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/4/26.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON


class EnterpriseVerificationTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let api = API.shared
    
    let businessLicenseImagePicker = UIImagePickerController()
    let positiveIDCardImagePicker = UIImagePickerController()
    let negativeIDCardImagePicker = UIImagePickerController()
    
    @IBOutlet weak var enterpriseNameTextField: UITextField!
    @IBOutlet weak var registerCodeTextField: UITextField!
    @IBOutlet weak var enterpriseLocationTextField: UITextField!
    
    
    @IBOutlet weak var businessLicenseImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idNumberTextField: UITextField!
    @IBOutlet weak var positiveIDCardImageView: UIImageView!
    @IBOutlet weak var negativeIDCardImageView: UIImageView!
    
    
    @IBAction func submit(_ sender: UIBarButtonItem) {
        nameTextField.resignFirstResponder()
        idNumberTextField.resignFirstResponder()
        enterpriseNameTextField.resignFirstResponder()
        enterpriseLocationTextField.resignFirstResponder()
        registerCodeTextField.resignFirstResponder()
        
        guard let enterpriseName = enterpriseNameTextField.text else {
            return
        }
        guard let registerCode = registerCodeTextField.text else {
            return
        }
        guard let enterpriseLocation = enterpriseLocationTextField.text else {
            return
        }
        guard let businessLicenseImage = businessLicenseImageView.image else {
            return
        }
        
        
        guard let name = nameTextField.text else {
            return
        }
        guard let idNumber = idNumberTextField.text else {
            return
        }
        guard let IDCardAImage = positiveIDCardImageView.image else {
            return
        }
        guard let IDCardBImage = negativeIDCardImageView.image else {
            return
        }
        
        let datas = ["access_token": API.token!.data(using: String.Encoding.utf8)!,
                     "legalperson": name.data(using: String.Encoding.utf8)!,
                     "legalpersonid": idNumber.data(using: String.Encoding.utf8)!,
                     "legalpersonidA": UIImagePNGRepresentation(IDCardAImage)!,
                     "legalpersonidB": UIImagePNGRepresentation(IDCardBImage)!,
                     
                     "license": UIImagePNGRepresentation(businessLicenseImage)!,
                     "enterprisename": enterpriseName.data(using: String.Encoding.utf8)!,
                     "enterprisecode": registerCode.data(using: String.Encoding.utf8)!,
                     "enterpriseaddress": enterpriseLocation.data(using: String.Encoding.utf8)!
                     ]
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        api.verifyPersonalNew(datas) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                print(res)
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
    }
    fileprivate func convertImageToBase64String(_ image: UIImage) -> String {
        let imageData = UIImagePNGRepresentation(image)!
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
}

extension EnterpriseVerificationTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            showImagePicker(businessLicenseImagePicker)
        case 3:
            showImagePicker(positiveIDCardImagePicker)
        case 4:
            showImagePicker(negativeIDCardImagePicker)
        default:
            break
        }
    }
}

extension EnterpriseVerificationTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePicker(_ imagePicker: UIImagePickerController) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        let sheet = UIAlertController(title: "选择", message: "选择从哪里获取图片", preferredStyle: .actionSheet)
        let takeAPhotoButtonAction = UIAlertAction(title: "拍照", style: .default, handler: { _ in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        let photoLibraryButtonAction = UIAlertAction(title: "从照片库选取图片", style: .default, handler: { _ in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            if let selection = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selection, animated: true)
            }
        })
        
        sheet.addAction(takeAPhotoButtonAction)
        sheet.addAction(photoLibraryButtonAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        switch picker {
        case businessLicenseImagePicker:
            businessLicenseImageView.image = chosenImage
        case positiveIDCardImagePicker:
            positiveIDCardImageView.image = chosenImage
        case negativeIDCardImagePicker:
            negativeIDCardImageView.image = chosenImage
        default:
            break
        }
        picker.dismiss(animated: true, completion: nil)
        
        
        
        //        let imageData = UIImagePNGRepresentation(chosenImage)!
        //        let imageBase64String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        //
        //
        //        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //        api.updateAvatar(["access_token": API.token!, "img": imageBase64String]) { response in
        //            switch response {
        //            case .Success:
        //                let res = JSON(data: response.value!)
        //                if res["status"].stringValue == "success" {
        ////                    self.avatarImageView.image = chosenImage
        //                } else if res["status"].stringValue == "failure" {
        //                    let alertTitle = "Error"
        //                    let alertMessage = res["error_description"].stringValue
        //
        //                    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        //                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
        //                    alertController.addAction(OKAction)
        //                    self.presentViewController(alertController, animated: true, completion: nil)
        //                }
        //            case .Failure(let error):
        //                print(error)
        //            }
        //            MBProgressHUD.hideHUDForView(self.view, animated: true)
        //        }
        //        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

