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
    
    public func parseResults(searchUrl: String?, delegate: AutoSearchPipeLineDelegate?) {
        guard let _ = resp else {
            return
        }
        root = Node()
        root?.key = searchUrl//NSLocalizedString("pika.main.title", comment: "ROOT")
        root?.value = resp
        parse(root)
        //NSLog((root?.description)!)
        delegate?.onParserResults(root)
    }
    
    private func parse(_ node: Node?) {
        
        guard let _ = node, let _ = node?.value else {
            return
        }
        
        guard let dict = (node?.value as? Dictionary<String, Any>) else {
            return
        }
        let componentArray = Array(dict.keys)
        for comp in componentArray {
            let nextNode = Node()
            nextNode.key = "\(String(describing: comp))"
            nextNode.value = dict[nextNode.key!]
            nextNode.parent = node
            node?.add(child: nextNode)
            parse(nextNode)
        }
        return
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
            text += " {"
            for child in children {
                if (children.last?.value as? String) != (child.value as? String) {
                    text += child.description + ", "
                } else {
                    text += child.description
                }
            }
            text += "} "
        }

        return text
    }
}

