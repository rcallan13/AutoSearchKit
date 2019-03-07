//
//  AutoSearchManager.swift
//  AutoSearchKit
//
//  Created by Ron Allan on 2019-03-07.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation

public protocol AutoSearchDelegate {
    func onSearchResults()
}

public class AutoSearchManager {
    
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
    
    var autoSearchParams: Response?
    var searchResults: [AutoSearchResult]?
    
    public init() {
        parseParameters()
    }
    
    public func search(autoSearchDelegate: AutoSearchDelegate) -> Bool {
        guard let _ = autoSearchParams else {
            return false
        }
        
        for entry in (autoSearchParams?.searchEntries)! {
            let type = entry.flavor
        }
        return true
    }
    
    private func parseParameters() {
        autoSearchParams = Util.readJsonFile("autosearch")
    
        NSLog("autoSearch: \(String(describing: autoSearchParams?.searchEntries[0].searchName))")
    }
    
    private func performSearch(_ urlPath: String) {
        
        let url = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        searchResults = Array<AutoSearchResult>()
        
        let webClient = WebClient()
        do {
            try webClient.get(urlPath: url!, successBlock: {(_ resp: Dictionary<String, Any>?) in
                
                guard let _ = resp else {
                    
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
            }, failureBlock: {(_ resp: String) in
                NSLog("Failure: " + resp)
            })
        } catch {
            NSLog("Failure - in catch")
        }
    }
}
