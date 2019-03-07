//
//  Util.swift
//  pika
//
//  Created by Ron Allan on 2019-03-06.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation

class Util {
    
    /**
     read in the json file
     */
    public static func readJsonFile(_ name: String) -> Response? {
        
        if let filepath = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let data = contents.data(using: .utf8)
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data!)
                return response
            } catch {
                // contents could not be loaded
                NSLog("Error: \(error)")
            }
        }
        return nil
    }
    
    
}
