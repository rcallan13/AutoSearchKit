//
//  SearchViewController.swift
//  See Me Soon
//
//  Created by Ron Allan on 2019-02-06.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import UIKit


/*
 Item: ["displayLink": play.google.com, "formattedUrl": https://play.google.com/store/apps/details?id=com...coinhelp..., "link": https://play.google.com/store/apps/details?id=com.mdurante.coinhelp&hl=en_US, "title": Coin Photo Grading - Coin Grading Images - Apps on Google Play, "kind": customsearch#result, "htmlTitle": <b>Coin</b> Photo Grading - <b>Coin</b> Grading Images - Apps on Google Play, "pagemap": {
 aggregaterating =     (
 {
 ratingvalue = "3.910839080810547";
 reviewcount = 572;
 }
 );
 "cse_image" =     (
 {
 src = "https://lh3.googleusercontent.com/ysefqu7UaUx9jnG3mndRVIntufj-Pz3qvZGyI-NdX8G6Hj5Ds-9pPCkRnR6o2EFD4pk";
 }
 );
 "cse_thumbnail" =     (
 {
 height = 157;
 src = "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQTTlfy5GZpx1h9H8aymn8ByRoq4thBE3r_s6UqG3YdPwozjAHm8TtVw-M";
 width = 321;
 }
 );
 metatags =     (
 {
 */
class AutoSearchViewController: UIViewController {
    
    let DEBUG = true
    
    let displayLinkKey = "displayLink"
    let formattedUrlKey = "formattedUrl"
    let linkKey = "link"
    let titleKey = "title"
    let htmlTitleKey = "htmlTitle"
    let pagemapKey = "pagemap"
    
    let aggregatingKey = "aggregaterating"
    let ratingvalueKey = "ratingvalue"
    let reviewCountKey = "reviewcount"
    let cseImageKey = "cse_image"
    let srcKey = "src"
    let cseThumbnailKey = "cse_thumbnail"
    
    var searchResults: Array<AutoSearchResult>?
    
    var input: UITextField?
    var output: UITextView?
    var submit: UIButton?
    var siteSelect: UISegmentedControl?
    var selectedCx: String = AutoSearchConst.GOOGLE_CX
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input = UITextField(frame: CGRect(x: 10, y: 40, width: self.view.frame.width - 68, height: 24))
        input?.borderStyle = .line
        self.view.addSubview(input!)
        submit = UIButton(frame: CGRect(x: self.view.frame.width - 58, y: 40, width: 50, height: 24))
        submit?.layer.borderColor = UIColor.darkGray.cgColor
        submit?.layer.borderWidth = 2
        submit?.setTitle("Submit", for: .normal)
        submit?.setTitleColor(UIColor.blue, for: .normal)
        submit?.setTitleColor(UIColor.lightGray, for: .selected)
        submit?.titleLabel?.font = UIFont(name: "Arial", size: 13)
        submit?.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        self.view.addSubview(submit!)
        
        //let siteItems = ["Google", "Yelp"]
        siteSelect = UISegmentedControl(frame: CGRect(x: 40, y: 80, width: self.view.frame.width - 80, height: 32))
        siteSelect?.insertSegment(withTitle: "Google", at: 0, animated: true)
        siteSelect?.insertSegment(withTitle: "Yelp", at: 1, animated: true)
        siteSelect?.setTitle("Google", forSegmentAt: 0)
        siteSelect?.setTitle("Yelp", forSegmentAt: 1)
        siteSelect?.selectedSegmentIndex = 0
        siteSelect?.addTarget(self, action: #selector(onValueChanged), for: .valueChanged)
        self.view.addSubview(siteSelect!)
        
        output = UITextView(frame: CGRect(x: 10, y: 120, width: self.view.frame.width - 20, height: self.view.frame.height - 120))
        self.view.addSubview(output!)
        output?.isScrollEnabled = true
    }
    
    @objc func onValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            selectedCx = AutoSearchConst.YELP_CX
        } else {
            selectedCx = AutoSearchConst.GOOGLE_CX
        }
    }
    
    /*
     https://stackoverflow.com/questions/8263493/ogtype-and-valid-values-constantly-being-parsed-as-ogtype-website
     */
    @objc func onSubmit(_ sender: UIButton) {
        
        var searchStr = input?.text
        searchStr = searchStr?.replacingOccurrences(of: " ", with: "+")
        
        performSearch(AutoSearchConst.GOOGLE_SEARCH_BASE + selectedCx + "&q=" + searchStr!)
        
        //performSearch("https://www.googleapis.com/customsearch/v1?key=AIzaSyBdeS6nNEse3XlSeDWXFGUNAvPqjdLSz3A&cx=008926720231001915476:zf_u0iwkv74&dateRestrict=y1&q=" + searchStr!)
    }
    
    private func performSearch(_ urlPath: String) {
        
        let url = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        searchResults = Array<AutoSearchResult>()
        
        let webClient = WebClient()
        do {
            try webClient.get(urlPath: url!, successBlock: {(_ resp: Dictionary<String, Any>?) in
                
                self.output?.text = ""
                guard let _ = resp else {
                    self.output?.text = "No Results"
                    return
                }
                let items = resp?["items"]
                guard let _ = items else {
                    var str = "No Results"
                    for (k, v) in resp! {
                        str.append("\n\n")
                        str.append(k)
                        str.append(" = ")
                        str.append((v as? String) ?? "N/A")
                    }
                    self.output?.text = str
                    return
                }
                
                for item in (items as! NSArray) {
                    guard let item = item as? Dictionary<String, Any> else {
                        continue
                    }
                    
                    
                    var searchResult = AutoSearchResult()
                    AutoSearchResult.count = 1
                    searchResult.keyArray = Array<String>()
                    searchResult.kvDict = Dictionary<String, Any?>()
                    //NSLog("Item: \(String(describing: item))")
                    
                    searchResult.displayLink = item[self.displayLinkKey] as? String
                    searchResult.formattedLink = item[self.formattedUrlKey] as? String
                    searchResult.htmlTitle = item[self.htmlTitleKey] as? String
                    
                    if let jsonObj = item[self.pagemapKey] as? Dictionary<String, Any> {
                        for (k,v) in jsonObj {
                            NSLog("Key k: \(k)")
                            //NSLog("Key/Value k: \(k) v: \(v)")
                            searchResult.keyArray?.append(k)
                            
                            if k == "metatags" {
                                if let metatags = v as? Array<Dictionary<String, Any?>> {
                                    
                                    searchResult.metatags = Dictionary<String, Any?>()
                                    for val in metatags {
                                        for (k,v) in val {
                                            //NSLog("metatags k: \(k) v: \(v)")
                                            searchResult.key = k
                                            searchResult.value = v
                                        }
                                    }
                                }
                            } else {
                                searchResult.kvDict?[k] = v
                            }
                        }
                    }
                    self.searchResults?.append(searchResult)
                    
                }
                
                var str = String()
                for var sr in self.searchResults! {
                    str.append(sr.toString())
                }
                DispatchQueue.main.async {
                    self.output?.textAlignment = .justified
                    self.output?.text = str
                }
            }, failureBlock: {(_ resp: String) in
                NSLog("Failure: " + resp)
            })
        } catch {
            NSLog("Failure - in catch")
        }
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
