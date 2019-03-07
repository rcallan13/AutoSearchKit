//
//  Response.swift
//  AutoSearchKit
//
//  Created by Ron Allan on 2019-03-07.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation

struct Response: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case searchEntries = "search_entries"
    }
    
    let searchEntries: [AutoSearchEntry]
}
