//
//  AutoSearchEntry.swift
//  AutoSearchKit
//
//  Created by Ron Allan on 2019-03-07.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation

public struct AutoSearchEntry: Codable {
    public let searchName: String?
    public let expression: String?
    public let location: String?
    public let flavor: String?
    
    private enum CodingKeys: String, CodingKey {
        case searchName = "search_name"
        case expression
        case location
        case flavor
    }
    
    public func toString() -> String {
        return searchName! + ": " + expression! + " @ " + location!
    }
}
