//
//  LaunchScreenViewController.swift
//  Partime
//
//  Created by ShinCurry on 15/12/19.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit
import DGActivityIndicatorView

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("viewDidLoad")
        launchingView = DGActivityIndicatorView(type: .BallBeat, tintColor: UIColor.grayColor(), size: 32.0)
        
        if let launch = launchingView {
            launch.frame.origin = CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0)
            view.addSubview(launch)
            print("launch")
            launch.startAnimating()
        } else {
            print("failed")
        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var launchingView: DGActivityIndicatorView?

}
