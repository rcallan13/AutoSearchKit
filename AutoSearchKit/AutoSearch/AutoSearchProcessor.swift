//
//  AutoSearchProcessor.swift
//  AutoSearchKit
//
//  Created by Ron Allan on 2019-03-14.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation

class AutoSearchProcessor {
    
    var pipelineDelegate: AutoSearchPipeLineDelegate?
    
    init(pipelineDelegate: AutoSearchPipeLineDelegate?) {
        self.pipelineDelegate = pipelineDelegate
    }
    
    func processResults(_ node: Node?) {
        let autoSearchResults = [AutoSearchResult]()
        pipelineDelegate?.onProcessorResults(autoSearchResults)
    }
}
