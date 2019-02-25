//
//  WebClient.swift
//  See Me Soon
//
//  Created by Ron Allan on 2019-02-05.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import UIKit

//
//  WebClient.swift
//  This class is responsible for making web service calls using URLSession. The response from a GET or POST request
//  is a Dictionary of the JSON values.
//

let DEBUG = true

public class WebClient {
    
    enum WebServiceError: Error {
        case emptyAccessToken
        case notFound
        case unAuthorized
        case noDataFound
    }
    
    public init() {
        
    }
    
    // ---- GET -----------------------------------------------------------
    public func get(urlPath: String, successBlock: @escaping (Dictionary<String, Any>)->(), failureBlock: @escaping (String) -> ()) throws {
        
        var request = URLRequest(url: URL(string: urlPath)!)
        request.httpMethod = "GET"
        request.addValue("com.rcal.See-Me-Soon", forHTTPHeaderField: "x-ios-bundle-identifier")
        if DEBUG {
            NSLog("GET: \(request)")
        }
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var jsonResp: Dictionary<String, Any>?
        
        // make the request
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async(execute: {
                    failureBlock("error=\(error!)")
                })
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                NSLog("statusCode should be 200, but is \(httpStatus.statusCode)")
                NSLog("response = \(response!)")
                DispatchQueue.main.async(execute: {
                    failureBlock("response = \(response!)")
                })
                return
            }
            
            jsonResp = self.handleResponse(data)
            //NSLog("JSON \(jsonResp!)")
            DispatchQueue.main.async(execute: {
                successBlock(jsonResp!)
            })
            
        }
        task.resume()
    }
    
    // ---- POST ----------------------------------------------------------------------
    public func post(urlPath: String, body: NSMutableData, contentType: String, successBlock: @escaping (Dictionary<String, Any>)->(), failureBlock: @escaping (String) -> ()) throws {
       
        var request = URLRequest(url: URL(string: urlPath)!)
        request.httpMethod = "POST"
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue("\(body.length)", forHTTPHeaderField: "Content-Length")
        request.addValue("com.rcal.See-Me-Soon", forHTTPHeaderField: "x-ios-bundle-identifier")
        
        request.httpBody = body as Data
        
        if DEBUG {
            NSLog("Content length: \(body.length)")
            NSLog("REQUEST: \(request.debugDescription)")
            for (key, value) in request.allHTTPHeaderFields! {
                NSLog("\(key)=\(value)")
            }
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var jsonResp: Dictionary<String, Any>?
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async(execute: {
                    failureBlock("error=\(error!)")
                })
                
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode > 399 {
                NSLog("statusCode should be 200, but is \(httpStatus.statusCode)")
                NSLog("response = \(response!)")
                DispatchQueue.main.async(execute: {
                    failureBlock("response = \(response!)")
                })
                return
            }
            let httpStatus = response as? HTTPURLResponse
            if DEBUG {
                NSLog("statusCode is \((httpStatus?.statusCode)!)")
                NSLog("response = \(response!)")
            }
            jsonResp = self.handleResponse(data)
            DispatchQueue.main.async(execute: {
                successBlock(jsonResp!)
            })
        }
        task.resume()
    }
    
    /*
     Parse the response
     */
    private func handleResponse(_ data: Data) -> Dictionary<String, Any> {
        do {
            guard let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, Any> else {
                print("error trying to convert data to JSON")
                return [:]
            }
            return jsonData
        } catch {
            NSLog("Parsing error while trying to parse JSON")
        }
        return [:]
    }
}


