//
//  GalaryDetailsViewController.swift
//  
//
//  Created by ShinCurry on 16/1/15.
//
//

import UIKit
import DGActivityIndicatorView

class GalleryDetailsViewController: UIViewController {
    
    var detailsLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionBarButton.enabled = false
        loadWebPage()
        // Do any additional setup after loading the view.
        
        loaderView = DGActivityIndicatorView(type: .BallSpinFadeLoader, tintColor: UIColor.grayColor(), size: 32.0)
        
        if let loader = loaderView {
            loader.frame.origin = CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0 - 60)
            webView.addSubview(loader)
            loader.startAnimating()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        if let tab = tabBarController {
            tab.tabBar.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let tab = tabBarController {
            tab.tabBar.hidden = false
        }
    }
    
    var loaderView: DGActivityIndicatorView?
    
    @IBOutlet weak var actionBarButton: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func actionBarButtonClicked(sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [NSURL(string: detailsLink!)!], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeMail, UIActivityTypePrint]        
        presentViewController(activityViewController, animated: true, completion: {})
    }
}

extension GalleryDetailsViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        if webView.stringByEvaluatingJavaScriptFromString("document.readyState") == "complete" {
            navigationItem.title = webView.stringByEvaluatingJavaScriptFromString("document.title")
            if let loader = loaderView {
                loader.stopAnimating()
                loader.hidden = true
            }
            if let colorString = webView.stringByEvaluatingJavaScriptFromString("document.body.style.backgroundColor") {
                view.backgroundColor = initColorWith(string: colorString)

            }
            

            actionBarButton.enabled = true
        } else {
            navigationItem.title = NSLocalizedString("webStatusLoadFailed", comment: "")
        }
    }
    
    private func loadWebPage() {
        webView.delegate = self
        if let link = detailsLink {
            let url = NSURL(string: link)!
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }
    
    private func initColorWith(string colorString: String) -> UIColor? {
        if colorString.hasPrefix("rgb(") {
            var color = (colorString as NSString).substringFromIndex(4)
            color = (color as NSString).substringToIndex(color.characters.count-1)
            let colorStringArray = color.componentsSeparatedByString(", ")
            let colorArray = colorStringArray.map({ c in return Float(c)! / 255.0 })
            return UIColor(colorLiteralRed: colorArray[0], green: colorArray[1], blue: colorArray[2], alpha: 1.00)
        } else {
            return UIColor.whiteColor()
        }
    }
}
