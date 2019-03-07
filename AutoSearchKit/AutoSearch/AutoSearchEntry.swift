//
//  AutoSearchEntry.swift
//  AutoSearchKit
//
//  Created by Ron Allan on 2019-03-07.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation

struct AutoSearchEntry: Codable {
    let searchName: String?
    let expression: String?
    let location: String?
    let flavors: String?
    
    private enum CodingKeys: String, CodingKey {
        case searchName = "search_name"
        case expression
        case location
        case flavors
    }
}
