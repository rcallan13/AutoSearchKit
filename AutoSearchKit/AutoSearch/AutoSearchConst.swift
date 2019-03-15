//
//  SearchConst.swift
//  See Me Soon
//
//  Created by Ron Allan on 2019-02-09.
//  Copyright © 2019 RCAL Software Solutions. All rights reserved.
//

import Foundation

public struct AutoSearchConst {
    
    public static let GOOGLE_HOST = "https://www.googleapis.com/customsearch/v1?"
    public static let GOOGLE_API_KEY = "AIzaSyBdeS6nNEse3XlSeDWXFGUNAvPqjdLSz3A"
    public static let GOOGLE_CX = "008926720231001915476:4akcjpl9cku"
    public static let YELP_CX = "008926720231001915476:zf_u0iwkv74"
    
    public static let GOOGLE_SEARCH_BASE = GOOGLE_HOST + "key=" + GOOGLE_API_KEY + "&cx="
    public static let GOOGLE_SITE = GOOGLE_SEARCH_BASE + GOOGLE_CX
    public static let YELP_SITE = GOOGLE_SEARCH_BASE + YELP_CX
    
    public static let displayLinkKey = "displayLink"
    public static let formattedUrlKey = "formattedUrl"
    public static let linkKey = "link"
    public static let titleKey = "title"
    public static let htmlTitleKey = "htmlTitle"
    public static let pagemapKey = "pagemap"
    
    public static let aggregatingKey = "aggregaterating"
    public static let ratingvalueKey = "ratingvalue"
    public static let reviewCountKey = "reviewcount"
    public static let cseImageKey = "cse_image"
    public static let srcKey = "src"
    public static let cseThumbnailKey = "cse_thumbnail"
}
