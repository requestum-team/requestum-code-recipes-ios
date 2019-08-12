//
//  Method.swift
//  FRIDAY
//
//  Created by Dima Hapich on 6/10/19.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation

import Alamofire

extension HTTP {
    
    public enum Method: String {
        
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
        
        public func asAlamofireHTTPMethod() -> Alamofire.HTTPMethod {
            
            guard let method = Alamofire.HTTPMethod(rawValue: rawValue) else {
                return .get
            }
            
            return method
        }
    }
}
