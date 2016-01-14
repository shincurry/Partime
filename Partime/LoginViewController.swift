//
//  LoginViewController.swift
//  Partime
//
//  Created by ShinCurry on 15/12/18.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegate()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        addKeyboardNotification()
    }
    override func viewWillDisappear(animated: Bool) {
        removeKeyboardNotification()
    }
    
    
    // hide keyboard when touch background
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var inputAccountView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signInButton(sender: UIButton) {
        if Account.verify(username: usernameTextField.text!, password: passwordTextField.text!) {
            
        } else {
            
        }

    }

    @IBAction func signUpButton(sender: UIButton) {
        
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
    
        let move = (inputViewFrame.origin.y + inputViewFrame.size.height) - (keyboardRect?.origin.y)! + 30
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

// MARK: Delegate - set Keyboard Return Key
extension LoginViewController: UITextFieldDelegate {
    func setTextFieldDelegate() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
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
