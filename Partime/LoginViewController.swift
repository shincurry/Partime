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
    
    
    // hide keyboard when touch background
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    let api = API.shared

    var loginStatus = false
    var loginType = FormatType.id
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
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "UnwindLoginOKToProfileTableViewController":
                let controller = segue.destination as! ProfileTableViewController
                controller.updateLoginStatus()
                
            case "ShowRegisterSegue":
                let controller = segue.destination as! RegisterViewController
                controller.type = .register
                controller.superController = self
            case "ShowForgotPasswordSegue":
                let controller = segue.destination as! RegisterViewController
                controller.type = .forgotPassword
            default:
                break
            }
        }
    }
    
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        if !username.isEmpty && !password.isEmpty {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            api.login(["phonenumber": username as AnyObject, "password": password as AnyObject]) { response in
                switch response {
                case .success:
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
                        let alertController = UIAlertController(title: "Success", message: "Login successfully", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { _ in
                            self.performSegue(withIdentifier: "UnwindLoginOKToProfileTableViewController", sender: self)
                        })
                        
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                    if res["status"].stringValue == "failure" {
                        
                        let alertTitle = "Error"
                        let alertMessage = res["error_description"].stringValue
                        
                        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                    let alertController = UIAlertController(title: "Get validate code error", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                MBProgressHUD.hide(for: self.view, animated: true)
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
        api.getProfile(["access_token": API.token! as AnyObject]) { response in
            switch response {
            case .success:
                let res = JSON(data: response.value!)
                let data = res["result"]
                let defaults = UserDefaults(suiteName: "ProfileDefaults")!
                defaults.set(data["phone"].stringValue, forKey: "ProfileTelephone")
                defaults.set(data["realname"].stringValue, forKey: "ProfileRealname")
                defaults.set(data["gender"].stringValue, forKey: "ProfileGender")
                defaults.set(data["birthday"].stringValue, forKey: "ProfileBirthday")
                
                defaults.set(data["districtid"].stringValue, forKey: "ProfileDistrictID")
                defaults.set(data["cityid"].stringValue, forKey: "ProfileCityID")
                defaults.set(data["provinceid"].stringValue, forKey: "ProfileProvinceID")
                defaults.set(data["city"].stringValue + " " + data["district"].stringValue, forKey: "ProfileLocationName")
                
                
                if let qq = data["qq"].string {
                    defaults.set(qq, forKey: "ProfileQQ")
                } else {
                    defaults.set("", forKey: "ProfileQQ")
                }
                if let email = data["email"].string {
                    defaults.set(email, forKey: "ProfileEmail")
                } else {
                    defaults.set("", forKey: "ProfileEmail")
                }

                
                if let stature = data["height"].string {
                    if let value = Int(stature) {
                        defaults.set(value, forKey: "ProfileStature")
                    }
                } else {
                    defaults.set(0, forKey: "ProfileStature")
                }
                if let school = data["school"].string {
                    defaults.set(school, forKey: "ProfileSchool")
                } else {
                    defaults.set("", forKey: "ProfileSchool")
                }
                if let major = data["major"].string {
                    defaults.set(major, forKey: "ProfileMajor")
                } else {
                    defaults.set("", forKey: "ProfileMajor")
                }
                if let enrollYear = data["enrolyear"].string {
                    defaults.set(enrollYear, forKey: "ProfileEnrollYear")
                } else {
                    defaults.set("", forKey: "ProfileEnrollYear")
                }
                if let intro = data["introduction"].string {
                    defaults.set(intro, forKey: "ProfileIntroduction")
                } else {
                    defaults.set("", forKey: "ProfileIntroduction")
                }
                if let exp = data["workexperience"].string {
                    defaults.set(exp, forKey: "ProfileWorkExperience")
                } else {
                    defaults.set("", forKey: "ProfileWorkExperience")
                }
                if let avatar = data["protrait"].string {
                    defaults.set(avatar, forKey: "ProfileAvatar")
                } else {
                    defaults.set("", forKey: "ProfileAvatar")
                }
                if let cert = data["personcerticification"].int {
                    let bool = cert == 29 ? false : true
                    defaults.set(bool, forKey: "ProfileIsPersonalVerified")
                }
                if let cert = data["enterprisecertification"].int {
                    let bool = cert == 29 ? false : true
                    defaults.set(bool, forKey: "ProfileIsEnterpriseVerified")
                }
                
                defaults.synchronize()
            case .failure(let error):
                print(error)
            }
        }
    }
}




extension LoginViewController {
    fileprivate func initialViewStyle() {
        usernameTextField.leftView = SpringImageView(image: UIImage(named: "LoginUser"))
        usernameTextField.leftViewMode = .always
        if let view = usernameTextField.leftView {
            view.tintColor = UIColor.gray
        }
        
        passwordTextField.leftView = UIImageView(image: UIImage(named: "Key"))
        passwordTextField.leftViewMode = .always
        if let view = passwordTextField.leftView {
            view.tintColor = UIColor.gray
        }
        
        loginButton.backgroundColor = UIColor.lightGray
    }
}

// MARK: - Resize View when pop up keyboard
extension LoginViewController {
    func keyboardWillChangeFrame(_ notification: Notification) {
        var animationDuration: TimeInterval?
        let info: NSDictionary = notification.userInfo! as NSDictionary
        animationDuration =  info.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as? TimeInterval
        let keyboardRect = (info.object(forKey: UIKeyboardFrameEndUserInfoKey) as AnyObject).cgRectValue!
        let inputViewFrame = inputAccountView.frame
        let move = loginView.frame.origin.y + inputViewFrame.origin.y + inputViewFrame.size.height + (keyboardRect.size.height) - view.frame.size.height - 20
        if (move > 0) {
            UIView.animate(withDuration: animationDuration!, animations: {
                self.view.bounds.origin.y = move
            })
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        var animationDuration: TimeInterval?
        let info: NSDictionary = notification.userInfo! as NSDictionary
        animationDuration =  info.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as? TimeInterval
    
        UIView.animate(withDuration: animationDuration!, animations: {
                self.view.bounds.origin.y = 0
        })
    }
    
    func addKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

// MARK: Delegate - username and password text field delegate
extension LoginViewController: UITextFieldDelegate {
    
    @IBAction func usernameTextChanged(_ sender: UITextField) {
        let (accountResult, typeResult, passwordResult)  = login.verify(account: username, password: password)
        changeTextFieldIcon(typeResult)
        loginButtonAnimate(accountResult && passwordResult)
    }
    @IBAction func passwordTextChanged(_ sender: UITextField) {
        let (accountResult, typeResult, passwordResult)  = login.verify(account: username, password: password)
        changeTextFieldIcon(typeResult)
        loginButtonAnimate(accountResult && passwordResult)
    }
    
    fileprivate func loginButtonAnimate(_ current: Bool) {
        loginButton.animation = "pop"
        loginButton.force = 0.3
        
        if current != loginStatus {
            loginStatus = current
            if loginStatus {
                loginButton.backgroundColor = Theme.mainColor
            } else {
                loginButton.backgroundColor = UIColor.lightGray
            }
            loginButton.animate()
        }
    }
    
    fileprivate func changeTextFieldIcon(_ type: FormatType) {
        var type = type
        guard let view = usernameTextField.leftView as? SpringImageView else {
            print("have no left view")
            return
        }
        if (type == .none) {
            type = .id
        }
        
        if loginType != type {
            switch type {
            case .email:
                view.image = UIImage(named: "LoginMail")
            case .phoneNumber:
                view.image = UIImage(named: "LoginTelephone")
            case .id:
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField === passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
