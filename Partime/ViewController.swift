//
//  ViewController.swift
//  Partime
//
//  Created by ShinCurry on 15/12/18.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var isLogin: Bool = false;

    
    override func viewDidLoad() {
        isLogin = false;
        if (isLogin) {
            print("Login");
        } else {
            print("not login");
        }
        

        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

