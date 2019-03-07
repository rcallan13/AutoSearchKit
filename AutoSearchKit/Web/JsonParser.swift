//
//  JsonParser.swift
//  See Me Soon
//
//  Created by Ron Allan on 2019-02-05.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//
import Foundation

public class JsonParser {
    
    public init() {
        
    }
    
    /**
     */
    public func parseObject(data: Data) -> Dictionary<String, Any>?{
        
        var dict: Dictionary<String, Any>?
        do {
            let parsedData = try JSONSerialization.jsonObject(with: data as Data, options: [])
            
            //Store response in NSDictionary for easy access
            dict = (parsedData as? Dictionary<String, Any>)
            
            //else throw an error detailing what went wrong
        } catch let error as NSError {
            NSLog("Details of JSON parsing error:\n \(error)")
        }
        return dict
    }
    
    /**
     */
    public func parseArray(data: Data) -> [Dictionary<String, Any>] {
        
        var arr = [Dictionary<String, Any>]()
        do {
            let parsedData = try JSONSerialization.jsonObject(with: data as Data, options: []) as! [Any]
            
            for i in 0..<parsedData.count {
                arr.append(parsedData[i] as! [String : Any])
            }
            //else throw an error detailing what went wrong
        } catch let error as NSError {
            NSLog("Details of JSON parsing error:\n \(error)")
        }
        return arr
    }
}

