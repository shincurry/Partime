
//  AppDelegate.swift
//  Partime
//
//  Created by ShinCurry on 15/12/18.
//  Copyright © 2015年 ShinCurry. All rights reserved.
//

import UIKit
import KeychainAccess
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let _ = API.token {
            let keychain = Keychain(service: "com.windisco.Partime")
            
            API.shared.login(["phonenumber": keychain["username"]! as AnyObject, "password": keychain["password"]! as AnyObject]) { response in
                switch response {
                case .success:
                    let res = JSON(data: response.value!)
                    print(res)
                    if res["status"].stringValue == "success" {
                        keychain["accessToken"] = res["access_token"].stringValue
                        API.token = res["access_token"].stringValue
                    }
                case .failure:
                    break
                }
            }
        }
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "isNotFirstLaunch") {
            print("not first launch")
            
            
        } else {
            showGuideView()
            print("first launch")
            
            defaults.set(true, forKey: "isNotFirstLaunch")
            defaults.set("位置", forKey: "location")
            defaults.set(false, forKey: "isLogin")
            defaults.set(1, forKey: "galleryCount")
            
        }
        return true
    }
    
    func showGuideView() {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let guideViewController = storyBoard.instantiateViewController(withIdentifier: "GuideView")
        if let window = self.window {
            window.rootViewController = guideViewController
            window.makeKeyAndVisible()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

