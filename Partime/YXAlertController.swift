//
//  YXAlertController.swift
//  Partime
//
//  Created by ShinCurry on 16/4/3.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit


class YXAlert {
    
    func showNotificationAlert(_ title: String, message: String, sender: UIViewController, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
        alertController.addAction(OKAction)
        sender.present(alertController, animated: true, completion: completion)
    }
}
