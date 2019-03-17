//
//  AutoSearchProcessor.swift
//  AutoSearchKit
//
//  Created by Ron Allan on 2019-03-14.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation

class AutoSearchProcessor {
    
    var searchResults: [AutoSearchResult]?
    var pipelineDelegate: AutoSearchPipeLineDelegate?
    
    init(pipelineDelegate: AutoSearchPipeLineDelegate?) {
        self.pipelineDelegate = pipelineDelegate
    }
    
    func processResults(_ node: Node?) {
        searchResults = Array<AutoSearchResult>()
        let searchPath = node?.key
        let children = node?.children
        for child in children! {
            let key = child.key
            let value = child.value
            NSLog("KEY: \(String(describing: key))")
            NSLog("\t\tCOUNT: \(child.children.count)")
            if key == "items" {
                parseItems(searchPath, items: value)
            }
        }
        pipelineDelegate?.onProcessorResults(searchResults)
    }
    
    private func parseItems(_ searchPath: String?, items: Any?) {
        for item in (items as! NSArray) {
            guard let item = item as? Dictionary<String, Any> else {
                continue
            }
            
            var searchResult = AutoSearchResult()
            AutoSearchResult.count = 1
            searchResult.searchPath = searchPath
            searchResult.keyArray = Array<String>()
            searchResult.kvDict = Dictionary<String, Any?>()
            //NSLog("Item: \(String(describing: item))")
            
            searchResult.displayLink = item[AutoSearchConst.displayLinkKey] as? String
            searchResult.formattedLink = item[AutoSearchConst.formattedUrlKey] as? String
            searchResult.htmlTitle = item[AutoSearchConst.htmlTitleKey] as? String
            
            if let jsonObj = item[AutoSearchConst.pagemapKey] as? Dictionary<String, Any> {
                for (k,v) in jsonObj {
                    //NSLog("Key/Value k: \(k) v: \(v)")
                    searchResult.keyArray?.append(k)
                    
                    if k == "metatags" {
                        if let metatags = v as? Array<Dictionary<String, Any?>> {
                            
                            searchResult.metatags = Dictionary<String, Any?>()
                            for val in metatags {
                                for (k,v) in val {
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
    }
}
