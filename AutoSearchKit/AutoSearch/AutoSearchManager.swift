//
//  AutoSearchManager.swift
//  AutoSearchKit
//
//  Created by Ron Allan on 2019-03-07.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation

public protocol AutoSearchDelegate {
    func onSearchResults(_ searchResults: [NlpResult]?)
}

protocol AutoSearchPipeLineDelegate {
    func onParserResults(_ node: Node?)
    func onProcessorResults(_ searchResults: [NlpResult]?)
}

public class AutoSearchManager: AutoSearchPipeLineDelegate {
    
    public var keys: [String]?
    
    var autoSearchDelegate: AutoSearchDelegate?
    public var autoSearchParams: Response?
    
    public init() {
        keys = [String]()
        parseParameters()
    }
    
    public func search(autoSearchDelegate: AutoSearchDelegate) -> Bool {
        self.autoSearchDelegate = autoSearchDelegate
        guard let _ = autoSearchParams else {
            return false
        }
        
        for entry in (autoSearchParams?.searchEntries)! {
            var selectedCx: String = AutoSearchConst.GOOGLE_CX
            let type = entry.flavor
            if type == "business" {
                let expression = entry.expression
                let location = entry.location
                var searchStr = expression! + " " + location!
                searchStr = searchStr.replacingOccurrences(of: " ", with: "+")
                // GOOGLE_CX
                selectedCx = AutoSearchConst.YELP_CX
                keys?.append(AutoSearchConst.GOOGLE_SEARCH_BASE + selectedCx + "&q=" + searchStr)
                DispatchQueue.global(qos: .utility).async {
                    self.performSearch(AutoSearchConst.GOOGLE_SEARCH_BASE + selectedCx + "&q=" + searchStr)
                }
            }
        }
        return true
    }
    
    func onParserResults(_ node: Node?) {
        let processor = AutoSearchProcessor(pipelineDelegate: self)
        processor.processResults(node)
    }
    
    func onProcessorResults(_ searchResults: [NlpResult]?) {
        self.autoSearchDelegate?.onSearchResults(searchResults)
    }
    
    private func parseParameters() {
        autoSearchParams = Util.readJsonFile("autosearch")
    
        NSLog("autoSearch: \(String(describing: autoSearchParams?.searchEntries[0].searchName))")
    }
    
    private func performSearch(_ urlPath: String) {
        
        let url = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let webClient = WebClient()
        do {
            try webClient.get(urlPath: url!, successBlock: {(_ resp: Dictionary<String, Any>?) in
                
                guard let _ = resp else {
                    return
                }
                
                let parser = AutoSearchParser(response: resp)
                parser.parseResults(searchUrl: urlPath, delegate: self)
                
            }, failureBlock: {(_ resp: String) in
                NSLog("Failure: " + resp)
            })
        } catch {
            NSLog("Failure - in catch")
        }
    }
}
