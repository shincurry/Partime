//
//  LoginViewController.swift
//  Partime
//
//  Created by ShinCurry on 15/12/18.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit
import Spring
import KeychainAccess
import SwiftyJSON
import MBProgressHUD

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.becomeFirstResponder()
        initialViewStyle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        addKeyboardNotification()
        if let tab = tabBarController {
            tab.tabBar.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        removeKeyboardNotification()
        if let tab = tabBarController {
            tab.tabBar.hidden = false
        }
    }
    
    
    // hide keyboard when touch background
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    let api = API.shared

    var loginStatus = false
    var loginType = FormatType.ID
    var username: String {
        get {
           return usernameTextField.text!
        }
    }
    var password: String {
        get {
            return passwordTextField.text!
        }
    }
    
    let login = YXLogin()
    
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var inputAccountView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: SpringButton!
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "UnwindLoginOKToProfileTableViewController":
                let controller = segue.destinationViewController as! ProfileTableViewController
                controller.updateLoginStatus()                
            default:
                break
            }
        }
    }
    
    
    @IBAction func loginButtonClicked(sender: UIButton) {
        if !username.isEmpty && !password.isEmpty {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            api.login(["phonenumber": username, "password": password]) { response in
                switch response {
                case .Success:
                    let res = JSON(data: response.value!)
                    print(res)
                    
                    if res["status"].stringValue == "success" {
                        let keychain = Keychain(service: "com.windisco.Partime")
                        keychain["accessToken"] = res["access_token"].stringValue
                        API.token = res["access_token"].stringValue
                        
                        keychain["username"] = self.username
                        keychain["password"] = self.password
                        
                        self.saveProfileInfo()
                        self.passwordTextField.resignFirstResponder()
                        let alertController = UIAlertController(title: "Success", message: "Login successfully", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: { _ in
                            self.performSegueWithIdentifier("UnwindLoginOKToProfileTableViewController", sender: self)
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
                    print(error)
                    let alertController = UIAlertController(title: "Get validate code error", message: error.localizedDescription, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
                }
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        } else {
            loginButton.animation = "shake"
            loginButton.delay = 0.2
            loginButton.force = 1.0
            loginButton.duration = 0.8
            loginButton.curve = "spring"
            loginButton.animate()
        }
    }
    
    
    func saveProfileInfo() {
        api.getProfile(["access_token": API.token!]) { response in
            switch response {
            case .Success:
                let res = JSON(data: response.value!)
                print("getProfile")
                print(res)
                let data = res["result"]
                let defaults = NSUserDefaults(suiteName: "ProfileDefaults")!
                defaults.setObject(data["realname"].stringValue, forKey: "ProfileRealname")
                defaults.setObject(data["gender"].stringValue, forKey: "ProfileGender")
                defaults.setObject(data["birthday"].stringValue, forKey: "ProfileBirthday")
                defaults.setObject(data["cityid"].stringValue, forKey: "ProfileCityID")
                
                if let qq = data["qq"].string {
                    defaults.setObject(qq, forKey: "ProfileQQ")
                } else {
                    defaults.setObject("", forKey: "ProfileQQ")
                }
                if let email = data["email"].string {
                    defaults.setObject(email, forKey: "ProfileEmail")
                } else {
                    defaults.setObject("", forKey: "ProfileEmail")
                }

                
                if let stature = data["height"].string {
                    if let value = Int(stature) {
                        defaults.setInteger(value, forKey: "ProfileStature")
                    }
                } else {
                    defaults.setObject(0, forKey: "ProfileStature")
                }
                if let school = data["school"].string {
                    defaults.setObject(school, forKey: "ProfileSchool")
                } else {
                    defaults.setObject("", forKey: "ProfileSchool")
                }
                if let major = data["major"].string {
                    defaults.setObject(major, forKey: "ProfileMajor")
                } else {
                    defaults.setObject("", forKey: "ProfileMajor")
                }
                if let enrollYear = data["enrolyear"].string {
                    defaults.setObject(enrollYear, forKey: "ProfileEnrollYear")
                } else {
                    defaults.setObject("", forKey: "ProfileEnrollYear")
                }
                if let intro = data["introduction"].string {
                    defaults.setObject(intro, forKey: "ProfileIntroduction")
                } else {
                    defaults.setObject("", forKey: "ProfileIntroduction")
                }
                if let exp = data["workexperience"].string {
                    defaults.setObject(exp, forKey: "ProfileWorkExperience")
                } else {
                    defaults.setObject("", forKey: "ProfileWorkExperience")
                }
                if let avatar = data["protrait"].string {
                    defaults.setObject(avatar, forKey: "ProfileAvatar")
                } else {
                    defaults.setObject("", forKey: "ProfileAvatar")
                }
                
                defaults.synchronize()
                
                for key in defaults.dictionaryRepresentation().keys {
                    print("\(defaults.objectForKey(key) as? String)")
                }
            case .Failure(let error):
                print(error)
            }
            
            

        }
        
        
    }
}




extension LoginViewController {
    private func initialViewStyle() {
        usernameTextField.leftView = SpringImageView(image: UIImage(named: "LoginUser"))
        usernameTextField.leftViewMode = .Always
        if let view = usernameTextField.leftView {
            view.tintColor = UIColor.grayColor()
        }
        
        passwordTextField.leftView = UIImageView(image: UIImage(named: "Key"))
        passwordTextField.leftViewMode = .Always
        if let view = passwordTextField.leftView {
            view.tintColor = UIColor.grayColor()
        }
        
        loginButton.backgroundColor = UIColor.lightGrayColor()
    }
}

// MARK: - Resize View when pop up keyboard
extension LoginViewController {
    func keyboardWillChangeFrame(notification: NSNotification) {
        var animationDuration: NSTimeInterval?
        let info: NSDictionary = notification.userInfo!
        animationDuration =  info.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as? NSTimeInterval
        let keyboardRect = info.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue!
        let inputViewFrame = inputAccountView.frame
        let move = loginView.frame.origin.y + inputViewFrame.origin.y + inputViewFrame.size.height + (keyboardRect?.size.height)! - view.frame.size.height - 20
        if (move > 0) {
            UIView.animateWithDuration(animationDuration!, animations: {
                self.view.bounds.origin.y = move
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var animationDuration: NSTimeInterval?
        let info: NSDictionary = notification.userInfo!
        animationDuration =  info.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as? NSTimeInterval
    
        UIView.animateWithDuration(animationDuration!, animations: {
                self.view.bounds.origin.y = 0
        })
    }
    
    func addKeyboardNotification() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}

// MARK: Delegate - username and password text field delegate
extension LoginViewController: UITextFieldDelegate {
    
    @IBAction func usernameTextChanged(sender: UITextField) {
        let (accountResult, typeResult, passwordResult)  = login.verify(account: username, password: password)
        changeTextFieldIcon(typeResult)
        loginButtonAnimate(accountResult && passwordResult)
    }
    @IBAction func passwordTextChanged(sender: UITextField) {
        let (accountResult, typeResult, passwordResult)  = login.verify(account: username, password: password)
        changeTextFieldIcon(typeResult)
        loginButtonAnimate(accountResult && passwordResult)
    }
    
    private func loginButtonAnimate(current: Bool) {
        loginButton.animation = "pop"
        loginButton.force = 0.3
        
        if current != loginStatus {
            loginStatus = current
            if loginStatus {
                loginButton.backgroundColor = Theme.mainColor
            } else {
                loginButton.backgroundColor = UIColor.lightGrayColor()
            }
            loginButton.animate()
        }
    }
    
    private func changeTextFieldIcon(type: FormatType) {
        var type = type
        guard let view = usernameTextField.leftView as? SpringImageView else {
            print("have no left view")
            return
        }
        if (type == .None) {
            type = .ID
        }
        
        if loginType != type {
            switch type {
            case .Email:
                view.image = UIImage(named: "LoginMail")
            case .PhoneNumber:
                view.image = UIImage(named: "LoginTelephone")
            case .ID:
                view.image = UIImage(named: "LoginUser")
            default:
                break
            }
            view.animation = "swing"
            view.curve = "easeOut"
            view.duration = 0.5
            view.animate()
            loginType = type
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField === passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
