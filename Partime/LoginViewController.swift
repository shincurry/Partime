//
//  LoginViewController.swift
//  Partime
//
//  Created by ShinCurry on 15/12/18.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit
import Spring

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegate()
        
        
        
        usernameTextField.leftView = UIImageView(image: UIImage(named: "Username"))
        usernameTextField.leftViewMode = .Always
        if let view = usernameTextField.leftView {
            view.tintColor = UIColor.grayColor()
        }
        
        passwordTextField.leftView = UIImageView(image: UIImage(named: "Key"))
        passwordTextField.leftViewMode = .Always
        if let view = passwordTextField.leftView {
            view.tintColor = UIColor.grayColor()
        }
        

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
    
    var isUsernameOK = false
    var isPasswordOK = false
    var isLoginOK = false
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var inputAccountView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: SpringButton!
    
    @IBAction func loginButtonClicked(sender: UIButton) {
        if Account.verify(username: usernameTextField.text!, password: passwordTextField.text!) {
            
        } else {
            loginButton.animation = "shake"
            loginButton.delay = 0.2
            loginButton.force = 1.4
            loginButton.duration = 0.8
            loginButton.curve = "spring"
            loginButton.animate()
        }

    }

    @IBAction func signUpButtonClicked(sender: UIButton) {
        
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
        let move = loginView.frame.origin.y + inputViewFrame.origin.y + inputViewFrame.size.height + (keyboardRect?.size.height)! - view.frame.size.height
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}

// MARK: Delegate - username and password text field delegate
extension LoginViewController: UITextFieldDelegate {
    func setTextFieldDelegate() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    @IBAction func usernameTextChanged(sender: UITextField) {
        // temp verify input text
        print("usernameTextChanged")
        if let text = sender.text {
            if text.characters.count > 6 {
                isUsernameOK = true
            } else {
                isUsernameOK = false
            }
        }
        loginButtonAnimate()
        
        
    }
    @IBAction func passwordTextChanged(sender: UITextField) {
        print("passwordTextChanged")
        if let text = sender.text {
            if text.characters.count > 6 {
                isPasswordOK = true
            } else {
                isPasswordOK = false
            }
        }
        loginButtonAnimate()
    }
    
    private func loginButtonAnimate() {
        loginButton.animation = "pop"
        loginButton.force = 0.3
        if isLoginOK {
            if !isPasswordOK || !isUsernameOK {
                isLoginOK = false
                
                loginButton.backgroundColor = UIColor(red: 0.871, green: 0.110, blue: 0.157, alpha: 1.00)

                loginButton.animate()
            }
        } else {
            if isUsernameOK && isPasswordOK {
                isLoginOK = true
                loginButton.backgroundColor = UIColor(red: 0.039, green: 0.376, blue: 1.000, alpha: 1.00)
                loginButton.animate()
            }
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
