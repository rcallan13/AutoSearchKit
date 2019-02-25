//
//  SearchResult.swift
//  See Me Soon
//
//  Created by Ron Allan on 2019-02-06.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation

public struct AutoSearchResult {
    public static var count = 1
    public var title: String?
    public var htmlTitle: String?
    public var thumbnail: String?
    public var image: String?
    public var link: String?
    public var formattedLink: String?
    public var displayLink: String?
    public var ratingvalue: String?
    public var reviewCount: Int?
    
    public var metatags: Dictionary<String, Any?>?
    public var key: String?
    public var value: Any? {
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
    public var keyArray: Array<String>?
    public var kvDict: Dictionary<String, Any?>?
    
    public init() {
        
    }
    
    public mutating func toString() -> String {
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
