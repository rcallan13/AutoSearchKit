//
//  Response.swift
//  AutoSearchKit
//
//  Created by Ron Allan on 2019-03-07.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation

public struct Response: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case searchEntries = "search_entries"
    }
    
    public let searchEntries: [AutoSearchEntry]
}
