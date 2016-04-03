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

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func loginButtonClicked(sender: UIButton) {
        if !username.isEmpty && !password.isEmpty {
        
            api.login(["phonenumber": username, "password": password]) { (error, result) in
                if let err = error {
                    let alertController = UIAlertController(title: "Get validate code error", message: err.localizedDescription, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
                }
                if let res = result {
                    if res["error"] != nil {
                        let alertTitle = res["error"].description
                        let alertMessage = res["error_description"].description
                        
                        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                        return
                    }
                    
                    let keychain = Keychain(service: "com.windisco.Partime")
                    keychain["accessToken"] = res["access_token"].description
                    
                    let alertController = UIAlertController(title: "Success", message: "Login successfully", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true) {
                        self.performSegueWithIdentifier("UnwindToProfileTableViewController", sender: self)
                    }
                }
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
