//
//  AutoSearchManager.swift
//  AutoSearchKit
//
//  Created by Ron Allan on 2019-03-07.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation

public class AutoSearchManager {
    
    var autoSearchParams: Response?
    
    init() {
        parseParameters()
    }
    
    private func parseParameters() {
        autoSearchParams = Util.readJsonFile("autosearch")
        //NSLog("autoSearch: \(String(describing: autoSearchParams?["business"]))")
    }
}
