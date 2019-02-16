//
//  SearchResult.swift
//  See Me Soon
//
//  Created by Ron Allan on 2019-02-06.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation

struct AutoSearchResult {
    static var count = 1
    var title: String?
    var htmlTitle: String?
    var thumbnail: String?
    var image: String?
    var link: String?
    var formattedLink: String?
    var displayLink: String?
    var ratingvalue: String?
    var reviewCount: Int?
    
    var metatags: Dictionary<String, Any?>?
    var key: String?
    var value: Any? {
        didSet {
            NSLog("KEY: \(String(describing: key))")
            metatags?[key!] = value
            if key == "cse_thumbnail" {
                if let arr = value as? NSArray {
                    for i in arr {
                        NSLog("THUMB: \(i)")
                    }
                }
            }
        }
    }
    var keyArray: Array<String>?
    var kvDict: Dictionary<String, Any?>?
    
    mutating func toString() -> String {
        var s = String()
        //"--------\n\n"
       
        var items = String()
        for k in keyArray! {
            //items.append(k)
            //items.append("\n\n")
            if k == "metatags" {
                for (x, t) in metatags! {
                   // items.append("\t")
                   // items.append(x)
                   // items.append("\n")
                    if x == "og:title" {
                        title = String()
                        title?.append("\n\(AutoSearchResult.count). -------------------------------------------\n")
                        title?.append(t as! String)
                        s.append(title!)
                        s.append("\n\n")
                        AutoSearchResult.count += 1
                    }
                }
            } else {
                if k == "localbusiness" || k == "postaladdress" || k.contains("review") {
                    items.append(k)
                    items.append("\n")
                if let _ = kvDict?[k] as? String {
                    items.append("\t")
                    items.append((kvDict?[k] as? String)!)
                } else {
                    if let a = kvDict?[k] as? Array<Any?> {
                        for i in a {
                            items.append("\t")
                           items.append(String(describing: i!))
                            items.append("\n")
                            }
                        }
                    }
                }
            }
        }
        
        s.append(items)
        return s
    }
}
