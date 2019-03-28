//
//  AutoSearchProcessor.swift
//  AutoSearchKit
//
//  Created by Ron Allan on 2019-03-14.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation
import CoreML

/**
 * Contains the NLP processing and analysis
 */
class AutoSearchProcessor {
    
    var searchResults: [NlpResult]?
    var pipelineDelegate: AutoSearchPipeLineDelegate?
    
    init(pipelineDelegate: AutoSearchPipeLineDelegate?) {
        self.pipelineDelegate = pipelineDelegate
    }
    
    func processResults(_ node: Node?) {
        searchResults = Array<NlpResult>()
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
        //pipelineDelegate?.onProcessorResults(searchResults)
        analyzeResult()
        pipelineDelegate?.onProcessorResults(searchResults)
    }
    
    private func analyzeResult() {
        // take the searchResults and turn them into a json doc
        // of the format required by the model.
        // Analyze the results against the model and return the analysis to the caller.
        
    }
    
    private func parseItems(_ searchPath: String?, items: Any?) {
        for item in (items as! NSArray) {
            guard let item = item as? Dictionary<String, Any> else {
                continue
            }
            
            let searchResult = NlpResult()
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
    
    private func modelToJson(_ searchResults: [NlpResult]?) -> String? {
        
        return nil
    }
}

extension AutoSearchProcessor {
    
    func analyze(text: String) {
        /*
        let counts = wordCounts(text: text)
        let model = Poets()
        do {
            let prediction = try model.prediction(text: counts)
            updateWithPrediction(poet: prediction.author,
                                 probabilities: prediction.authorProbability)
        } catch {
            print(error)
        }
        */
    }
    
    func wordCount(text: String) -> [String: Double] {
        var dictionary: [String: Double] = [:]
        
        let tagger = NSLinguisticTagger(tagSchemes: [.tokenType], options: 0)
        let range = NSRange(text.startIndex..., in: text)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
        tagger.string = text
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { _, tokenRange, _ in
            let word = (text as NSString).substring(with: tokenRange)
            dictionary[word, default: 0] += 1
        }
        
        return dictionary
    }
}
