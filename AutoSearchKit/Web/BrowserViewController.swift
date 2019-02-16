//
//  SearchViewController.swift
//  See Me Soon
//
//  Created by Ron Allan on 2019-02-06.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var input: UITextField?
    var submit: UIButton?
    var webView: WKWebView?
    /*
    override func loadView() {
        //let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 10, y: 60, width: self.view.frame.width - 20, height: 200))
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        view.addSubview(webView!)
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        input = UITextField(frame: CGRect(x: 10, y: 40, width: self.view.frame.width - 80, height: 24))
        input?.borderStyle = .line
        self.view.addSubview(input!)
        submit = UIButton(frame: CGRect(x: self.view.frame.width - 70, y: 40, width: 60, height: 24))
        
        submit?.setTitle("Submit", for: .normal)
        submit?.setTitleColor(UIColor.blue, for: .normal)
        submit?.setTitleColor(UIColor.lightGray, for: .selected)
        submit?.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        self.view.addSubview(submit!)
        
        webView = WKWebView(frame: CGRect(x: 10, y: 60, width: self.view.frame.width - 20, height: 200))
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        view.addSubview(webView!)
    }
    
    @objc func onSubmit(_ sender: UIButton) {
        var searchStr = input?.text
        /*
        let myURL = URL(string:"https://www.google.com/search?q=" + searchStr! + "&rlz=1C5CHFA_enCA686CA686&oq=" + searchStr! + "&aqs=chrome..69i57j0l5.5294j0j4&sourceid=chrome&ie=UTF-8")
        NSLog("URL: \(String(describing: myURL))")
        let myRequest = URLRequest(url: myURL!)
        webView?.load(myRequest)
 */
        searchStr = searchStr?.replacingOccurrences(of: " ", with: "%20")
        let search = "https://www.google.com/search?q=" + searchStr! + "&rlz=1C5CHFA_enCA686CA686&oq=" + searchStr! + "&sourceid=chrome&ie=UTF-8"
        webView?.load(URLRequest(url: URL(string: search)!))
        
        webView?.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML.innerText") { (result, error) in
            if error == nil {
                NSLog("RESULT: \(String(describing: result))")
            }
        }
        /*
        NSString *loadPasswordJS =
            [NSString stringWithFormat:@"var passFields = document.querySelectorAll(\"input[type='password']\"); \
                for (var i = passFields.length>>> 0; i--;) { passFields[i].value ='%@';}", LoginHelper.touchIdPassword];
                dispatch_async(dispatch_get_main_queue(), ^{
                //autofill the form
                [webView stringByEvaluatingJavaScriptFromString: loadPasswordJS];
        */
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

