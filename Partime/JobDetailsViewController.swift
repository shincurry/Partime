//
//  JobDetailsViewController.swift
//  Partime
//
//  Created by ShinCurry on 16/1/14.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import UIKit

class JobDetailsViewController: UIViewController {

    var isFaved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favButton.setImage(UIImage(named: isFaved ? "Faved" : "Fav"), forState: .Normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var favButton: UIButton!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func favButtonClicked(sender: UIButton) {
        
        favButton.setImage(UIImage(named: isFaved ? "Fav" : "Faved"), forState: .Normal)
//        if let image = UIImage(named: isFaved ? "Fav" : "Faved") {
//            favButton.layer.contents = image.CGImage
//        }
        
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0.1, 1.0, 1.5]
        animation.keyTimes = [0.0, 0.5, 0.8, 1.0]
        animation.calculationMode = kCAAnimationLinear
        
        isFaved = !isFaved
        
        favButton.layer.addAnimation(animation, forKey: "SHOW")
 
        //        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        //        k.values = @[@(0.1),@(1.0),@(1.5)];
        //        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        //        k.calculationMode = kCAAnimationLinear;
        //
        //        i++;
        //        [self.button1.layer addAnimation:k forKey:@"SHOW"];
        //        [self.image1.layer addAnimation:k forKey:@"SHOW"];
    }

}
