//
//  RequestHeader.swift
//  FRIDAY
//
//  Created by Dima Hapich on 6/10/19.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation

extension HTTP {
    
    public enum RequestHeader: String {
        
        case accept             = "Accept"
        case acceptCharset      = "Accept-Charset"
        case acceptEncoding     = "Accept-Encoding"
        case acceptDatetime     = "Accept-Datetime"
        case acceptLanguage     = "Accept-Language"
        
        case authorization      = "Authorization"
        case cacheControl       = "Cache-Control"
        case connection         = "Connection"
        case cookie             = "Cookie"
        
        case contentType        = "Content-Type"
        case contentMD5         = "Content-MD5"
        case contentLength      = "Content-Length"
        
        case date               = "Date"
        case expect             = "Expect"
        case forwarded          = "Forwarded"
        case from               = "From"
        case host               = "Host"
        
        case ifMatch            = "If-Match"
        case ifModifiedSince    = "If-Modified-Since"
        case ifNoneMatch        = "If-None-Match"
        case ifRange            = "If-Range"
        case ifUnmodifiedSince  = "If-Unmodified-Since"
        
        case origin             = "Origin"
        
        case range              = "Range"
        case referer            = "Referer"
        case userAgent          = "User-Agent"
        case upgrade            = "Upgrade"
    }
}
