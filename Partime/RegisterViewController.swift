//
//  RegisterViewController.swift
//  Partime
//
//  Created by ShinCurry on 15/12/19.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit
import Spring
import SwiftyJSON
import MBProgressHUD

enum RegisterType {
    case Register
    case ForgotPassword
    case None
}

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch type {
        case .Register:
            titleLabel.text = "注册"
        case .ForgotPassword:
            titleLabel.text = "重设密码"
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let api = API.shared
    let alert = YXAlert()
    
    var type: RegisterType = .None
    
    
    var isPhoneNumberOK = false
    var isPasswordOK = false
    var isValidateCodeOK = false
    
    var validateCodeID: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: SpringTextField!
    @IBOutlet weak var validateCodeTextField: SpringTextField!
    @IBOutlet weak var getValidateCodeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: SpringTextField!

    @IBAction func phoneNumberDidEndEdit(sender: SpringTextField) {
        sender.layer.borderWidth = 1
        sender.layer.cornerRadius = 8
        sender.layer.masksToBounds = true
        if sender.text?.characters.count == 11 {
            sender.layer.borderColor = UIColor.clearColor().CGColor
            isPhoneNumberOK = true
        } else {
            sender.layer.borderColor = UIColor.redColor().CGColor
            isPhoneNumberOK = false
            seTextFieldAnimation(sender)
        }
    }
    @IBAction func passwordDidEndEdit(sender: SpringTextField) {
        sender.layer.borderWidth = 1
        sender.layer.cornerRadius = 8
        sender.layer.masksToBounds = true
        if confirmPasswordTextField.text == passwordTextField.text && !passwordTextField.text!.isEmpty  {
            sender.layer.borderColor = UIColor.clearColor().CGColor
            isPasswordOK = true
        } else {
            sender.layer.borderColor = UIColor.redColor().CGColor
            isPasswordOK = false
            seTextFieldAnimation(sender)
        }
    }
    @IBAction func validateCodeDidEndEdit(sender: SpringTextField) {
        sender.layer.borderWidth = 1
        sender.layer.cornerRadius = 8
        sender.layer.masksToBounds = true
        if !sender.text!.isEmpty {
            isValidateCodeOK = true
            sender.layer.borderColor = UIColor.clearColor().CGColor
        } else {
            isValidateCodeOK = false
            sender.layer.borderColor = UIColor.redColor().CGColor
            seTextFieldAnimation(sender)
        }
        
    }

    @IBAction func getValidateCode(sender: UIButton) {
        if let phoneNumber = phoneNumberTextField.text {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            var params: [String: AnyObject] = ["phonenumber": phoneNumber]
            if type == .ForgotPassword {
                params["isforgot"] = 1
            }
            print(params)
            api.getValidateCode(params) { response in
                
                switch response {
                case .Success:
                    let res = JSON(data: response.value!)
                    print(res)
                    if res["status"].stringValue == "success" {
                        self.validateCodeID = res["validatecodeid"].stringValue
                        let alertController = UIAlertController(title: "Success", message: "Get validate code successfully", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                        sender.enabled = false
                        sender.backgroundColor = UIColor.lightGrayColor()
                    }
                    
                    if res["status"].stringValue == "failure" {
                        //                        print(res["error_description"])
                        let alertTitle = "Error"
                        let alertMessage = res["error_description"].stringValue
                        self.alert.showNotificationAlert(alertTitle, message: alertMessage, sender: self, completion: nil)
                    }
                    
                case .Failure(let error):
                    let alertController = UIAlertController(title: "Get validate code error", message: error.localizedDescription, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        }
        
    }
    
    @IBAction func confirmSignUp(sender: UIButton) {
        confirmPasswordTextField.resignFirstResponder()
        
        guard isPhoneNumberOK && isPasswordOK && isValidateCodeOK else {
            let alertController = UIAlertController(title: "Information Error", message: "Information you input is wrong", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        let params = ["phonenumber": phoneNumberTextField.text!,
                      "validatecode": validateCodeTextField.text!,
                      "validatecodeid": validateCodeID!,
                      "password": passwordTextField.text!
        ]
        
        switch type {
        case .Register:
            register(params)
        case .ForgotPassword:
            forgotPassword(params)
        default:
            break
        }
        
        
    }
    
    func register(params: [String: String]) {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        api.register(params) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                if res["status"].stringValue == "success" {
                    API.token = res["access_token"].stringValue
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    let alertTitle = "成功"
                    let alertMessage = "注册账号成功"
                    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: { _ in
                        self.performSegueWithIdentifier("UnwindRegisterToProfileSegue", sender: self)
                    })
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
                if res["status"].stringValue == "failure" {
                    let alertTitle = "Error"
                    let alertMessage = res["error_description"].stringValue
                    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            case .Failure(let error):
                let alertController = UIAlertController(title: "Get validate code error", message: error.localizedDescription, preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    func forgotPassword(params: [String: String]) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        api.forgotPassword(params) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                if res["status"].stringValue == "success" {
                    API.token = res["access_token"].stringValue
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    let alertTitle = "成功"
                    let alertMessage = "重设密码成功"
                    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: { _ in
                        self.performSegueWithIdentifier("UnwindRegisterToLoginSegue", sender: self)
                    })
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
                if res["status"].stringValue == "failure" {
                    let alertTitle = "Error"
                    let alertMessage = res["error_description"].stringValue
                    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            case .Failure(let error):
                let alertController = UIAlertController(title: "Get validate code error", message: error.localizedDescription, preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
}

// MARK: - View Animation
extension RegisterViewController {
    func seTextFieldAnimation(sender: SpringTextField) {
        sender.animation = "shake"
        sender.force = 0.3
        sender.duration = 0.4
        sender.curve = "spring"
        sender.animate()
    }
}
