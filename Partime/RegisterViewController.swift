//
//  RegisterViewController.swift
//  Partime
//
//  Created by ShinCurry on 15/12/19.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit
import Spring

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let api = API.shared
    
    
    var isPhoneNumberOK = false
    var isPasswordOK = false
    var isValidateCodeOK = false
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
            api.getValidateCode(["phonenumber": phoneNumber]) { (error, result) in
                if let err = error {
                    let alertController = UIAlertController(title: "Get validate code error", message: err.localizedDescription, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
                }
                if let res = result {
                    if res["error"] != nil {
//                        print(res["error"])
//                        print(res["error_description"])
                        let alertTitle = res["error"].description
                        let alertMessage = res["error_description"].description
                        
                        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                        return
                    }
                    print(res["status"].description)
                    let alertController = UIAlertController(title: "Success", message: "Get validate code successfully", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    sender.enabled = false
                    sender.backgroundColor = UIColor.lightGrayColor()
                }
                
                
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
        
        api.register(["phonenumber": phoneNumberTextField.text!, "validatecode": validateCodeTextField.text!, "password": passwordTextField.text!]) { (error, result) in
            if let err = error {
                let alertController = UIAlertController(title: "Get validate code error", message: err.localizedDescription, preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            if let res = result {
                if res["error"] != nil {
//                    print(res["error"])
//                    print(res["error_description"])
                    let alertTitle = res["error"].description
                    let alertMessage = res["error_description"].description
                    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    return
                }
                print(res["status"].description)
                
            }
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
