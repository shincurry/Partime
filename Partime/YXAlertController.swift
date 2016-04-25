//
//  YXAlertController.swift
//  Partime
//
//  Created by ShinCurry on 16/4/3.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit


class YXAlert {
    
    func showNotificationAlert(title: String, message: String, sender: UIViewController, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .Default, handler: nil)
        alertController.addAction(OKAction)
        sender.presentViewController(alertController, animated: true, completion: completion)
    }
}
