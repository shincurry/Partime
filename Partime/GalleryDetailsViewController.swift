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
        actionBarButton.isEnabled = false
        loadWebPage()
        // Do any additional setup after loading the view.
        
        loaderView = DGActivityIndicatorView(type: .ballClipRotateMultiple, tintColor: Theme.mainColor, size: 64.0)
        
        if let loader = loaderView {
            loader.frame.origin = CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0 - 50)
            webView.addSubview(loader)
            loader.startAnimating()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let tab = tabBarController {
            tab.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let tab = tabBarController {
            tab.tabBar.isHidden = false
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

    @IBAction func actionBarButtonClicked(_ sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [URL(string: detailsLink!)!], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.mail, UIActivityType.print]        
        present(activityViewController, animated: true, completion: {})
    }
}

extension GalleryDetailsViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if webView.stringByEvaluatingJavaScript(from: "document.readyState") == "complete" {
            navigationItem.title = webView.stringByEvaluatingJavaScript(from: "document.title")
            if let loader = loaderView {
                loader.stopAnimating()
                loader.isHidden = true
            }
            if let colorString = webView.stringByEvaluatingJavaScript(from: "document.body.style.backgroundColor") {
                view.backgroundColor = initColorWith(string: colorString)

            }
            

            actionBarButton.isEnabled = true
        } else {
            navigationItem.title = NSLocalizedString("webStatusLoadFailed", comment: "")
        }
    }
    
    fileprivate func loadWebPage() {
        webView.delegate = self
        if let link = detailsLink {
            let url = URL(string: link)!
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
    
    fileprivate func initColorWith(string colorString: String) -> UIColor? {
        if colorString.hasPrefix("rgb(") {
            var color = (colorString as NSString).substring(from: 4)
            color = (color as NSString).substring(to: color.characters.count-1)
            let colorStringArray = color.components(separatedBy: ", ")
            let colorArray = colorStringArray.map({ c in return Float(c)! / 255.0 })
            return UIColor(colorLiteralRed: colorArray[0], green: colorArray[1], blue: colorArray[2], alpha: 1.00)
        } else {
            return UIColor.white
        }
    }
}
