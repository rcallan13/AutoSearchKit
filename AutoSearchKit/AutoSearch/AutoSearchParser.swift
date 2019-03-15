//
//  SearchResultsParser.swift
//  AutoSearchKit
//
//  Created by Ron Allan on 2019-03-14.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation

class AutoSearchParser {
    
    var resp: Dictionary<String, Any>?
    var root: Node?
    
    public init(response: Dictionary<String, Any>?) {
        self.resp = response
    }
    
    public func parseResults(delegate: AutoSearchPipeLineDelegate?) {
        guard let _ = resp else {
            return
        }
        let root = Node()
        root.key = NSLocalizedString("pika.main.title", comment: "ROOT")
        root.value = resp
        parse(root)
        NSLog(root.description)
        delegate?.onParserResults(root)
    }
    
    private func parse(_ node: Node) {
        
        guard let _ = node.value else {
            return
        }
        
        guard let dict = (node.value as? Dictionary<String, Any>) else {
            return
        }
        let componentArray = Array(dict.keys)
        for comp in componentArray {
            let nextNode = Node()
            nextNode.key = "\(String(describing: comp))"
            nextNode.value = dict[comp]
            nextNode.parent = node
            node.add(child: nextNode)
            parse(nextNode)
        }
        return
    }
    
    private func parse_orig() -> Node? {
        
        let items = resp?["items"]
        guard let _ = items else {
            var str = "No Results"
            for (k, v) in resp! {
                str.append("\n\n")
                str.append(k)
                str.append(" = ")
                str.append((v as? String) ?? "N/A")
            }
            
            return nil
        }
        
        let componentArray = Array((resp?.keys)!)
        for comp in componentArray {
            NSLog("KEY: \(comp)")
            let value = resp?[comp]
            NSLog("VALUE: \(value ?? "NONE")")
        }
        
        //NSLog("RESP: \(String(describing: resp))")
        //NSLog("Queries: \(String(describing: resp?["queries"]))")
        //NSLog("KEYS: \(String(describing: resp?["keys"]))")
        //NSLog("ITEMS: \(String(describing: items))")
        
        for item in (items as! NSArray) {
            guard let item = item as? Dictionary<String, Any> else {
                continue
            }
            
            var searchResult = AutoSearchResult()
            AutoSearchResult.count = 1
            searchResult.keyArray = Array<String>()
            searchResult.kvDict = Dictionary<String, Any?>()
            NSLog("Item: \(String(describing: item))")
            
            searchResult.displayLink = item[AutoSearchConst.displayLinkKey] as? String
            searchResult.formattedLink = item[AutoSearchConst.formattedUrlKey] as? String
            searchResult.htmlTitle = item[AutoSearchConst.htmlTitleKey] as? String
            
            if let jsonObj = item[AutoSearchConst.pagemapKey] as? Dictionary<String, Any> {
                for (k,v) in jsonObj {
                    NSLog("Key/Value k: \(k) v: \(v)")
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
            //NSLog("SearchResult: \(searchResult.toString())")
            
        }
        return nil
    }
}

class Node {
    var key: String?
    var value: Any?
    var children: [Node] = []
    weak var parent: Node?
    
    init() {
    }
    
    func add(child: Node) {
        children.append(child)
        child.parent = self
    }
}

extension Node: CustomStringConvertible {
    
    var description: String {
        var text = "\(key ?? "(?)")=\(value ?? "(?)")"
        
        if !children.isEmpty {
            text += " {" + children.map { $0.description }.joined(separator: ", ") + "} "
        }
        return text
    }
}

