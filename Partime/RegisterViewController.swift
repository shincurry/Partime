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
import KeychainAccess

enum RegisterType {
    case register
    case forgotPassword
    case none
}

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch type {
        case .register:
            navigationItem.title = "注册"
        case .forgotPassword:
            navigationItem.title = "重设密码"
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardNotification()
        if let tab = tabBarController {
            tab.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardNotification()
        if let tab = tabBarController {
            tab.tabBar.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let api = API.shared
    let alert = YXAlert()
    
    var type: RegisterType = .none
    
    
    var isPhoneNumberOK = false
    var isPasswordOK = false
    var isValidateCodeOK = false
    
    var validateCodeID: String?
    
    var superController: LoginViewController?
    
    @IBOutlet weak var phoneNumberTextField: SpringTextField!
    @IBOutlet weak var validateCodeTextField: SpringTextField!
    @IBOutlet weak var getValidateCodeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: SpringTextField!

    func addKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "UnwindRegisterToProfileSegue":
                let controller = segue.destination as! ProfileTableViewController
                controller.updateLoginStatus()
            default:
                break
            }
            
        }
    }
    
    
    
    @IBAction func phoneNumberDidEndEdit(_ sender: SpringTextField) {
        sender.layer.borderWidth = 1
        sender.layer.cornerRadius = 8
        sender.layer.masksToBounds = true
        if sender.text?.characters.count == 11 {
            sender.layer.borderColor = UIColor.clear.cgColor
            isPhoneNumberOK = true
        } else {
            sender.layer.borderColor = UIColor.red.cgColor
            isPhoneNumberOK = false
            seTextFieldAnimation(sender)
        }
    }
    @IBAction func passwordDidEndEdit(_ sender: SpringTextField) {
        sender.layer.borderWidth = 1
        sender.layer.cornerRadius = 8
        sender.layer.masksToBounds = true
        if confirmPasswordTextField.text == passwordTextField.text && !passwordTextField.text!.isEmpty  {
            sender.layer.borderColor = UIColor.clear.cgColor
            isPasswordOK = true
        } else {
            sender.layer.borderColor = UIColor.red.cgColor
            isPasswordOK = false
            seTextFieldAnimation(sender)
        }
    }
    @IBAction func validateCodeDidEndEdit(_ sender: SpringTextField) {
        sender.layer.borderWidth = 1
        sender.layer.cornerRadius = 8
        sender.layer.masksToBounds = true
        if !sender.text!.isEmpty {
            isValidateCodeOK = true
            sender.layer.borderColor = UIColor.clear.cgColor
        } else {
            isValidateCodeOK = false
            sender.layer.borderColor = UIColor.red.cgColor
            seTextFieldAnimation(sender)
        }
        
    }

    @IBAction func getValidateCode(_ sender: UIButton) {
        if let phoneNumber = phoneNumberTextField.text {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            var params: [String: AnyObject] = ["phonenumber": phoneNumber as AnyObject]
            if type == .forgotPassword {
                params["isforgot"] = 1 as AnyObject?
            }
            print(params)
            api.getValidateCode(params) { response in
                
                switch response {
                case .success:
                    let res = JSON(data: response.value!)
                    print(res)
                    if res["status"].stringValue == "success" {
                        self.validateCodeID = res["validatecodeid"].stringValue
                        let alertController = UIAlertController(title: "成功", message: "成功获取验证码", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "好的", style: .default, handler: nil)
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion: nil)
                        sender.isEnabled = false
                        sender.backgroundColor = UIColor.lightGray
                    }
                    
                    if res["status"].stringValue == "failure" {
                        self.alert.showNotificationAlert("失败", message: "获取验证码失败", sender: self, completion: nil)
                    }
                    
                case .failure(let error):
                    let alertController = UIAlertController(title: "Get validate code error", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        
    }
    
    @IBAction func confirmSignUp(_ sender: UIButton) {
        confirmPasswordTextField.resignFirstResponder()
        
        guard isPhoneNumberOK && isPasswordOK && isValidateCodeOK else {
            let alertController = UIAlertController(title: "Information Error", message: "Information you input is wrong", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let params = ["phonenumber": phoneNumberTextField.text!,
                      "validatecode": validateCodeTextField.text!,
                      "validatecodeid": validateCodeID!,
                      "password": passwordTextField.text!
        ]
        
        switch type {
        case .register:
            register(params)
        case .forgotPassword:
            forgotPassword(params)
        default:
            break
        }
        
        
    }
    
    func register(_ params: [String: String]) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        api.register(params as [String : AnyObject]) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                if res["status"].stringValue == "success" {
                    let keychain = Keychain(service: "com.windisco.Partime")
                    keychain["accessToken"] = res["access_token"].stringValue
                    API.token = res["access_token"].stringValue
                    
                    keychain["username"] = self.phoneNumberTextField.text
                    keychain["password"] = self.passwordTextField.text
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let alertController = UIAlertController(title: "成功", message: "注册账号成功", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "好的", style: .default, handler: { _ in
                        self.performSegue(withIdentifier: "UnwindRegisterToProfileSegue", sender: self)
                        self.superController!.performSegue(withIdentifier: "UnwindLoginOKToProfileTableViewController", sender: self)
                    })
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                if res["status"].stringValue == "failure" {
                    let alertController = UIAlertController(title: "失败", message: "注册失败", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            case .failure(let error):
                let alertController = UIAlertController(title: "Get validate code error", message: error.localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func forgotPassword(_ params: [String: String]) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        api.forgotPassword(params as [String : AnyObject]) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                if res["status"].stringValue == "success" {
                    API.token = res["access_token"].stringValue
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let alertController = UIAlertController(title: "成功", message: "重设密码成功", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "好的", style: .default, handler: { _ in
                        self.performSegue(withIdentifier: "UnwindRegisterToLoginSegue", sender: self)
                    })
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                if res["status"].stringValue == "failure" {
                    let alertController = UIAlertController(title: "失败", message: "重设密码出错", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "好的", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            case .failure(let error):
                let alertController = UIAlertController(title: "Get validate code error", message: error.localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
}

// MARK: - View Animation
extension RegisterViewController {
    func seTextFieldAnimation(_ sender: SpringTextField) {
        sender.animation = "shake"
        sender.force = 0.3
        sender.duration = 0.4
        sender.curve = "spring"
        sender.animate()
    }
}
