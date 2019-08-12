//
//  URLConvertible.swift
//  FRIDAY
//
//  Created by Dima Hapich on 6/10/19.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation

public protocol URLConvertible {
    
    func asURL() -> URL
}

extension String: URLConvertible {
    
    public func asURL() -> URL {
        return URL(string: self)!
    }
}

extension URL: URLConvertible {
    
    public func asURL() -> URL {
        return self
    }
}

extension URLComponents: URLConvertible {
    
    public func asURL() -> URL {
        return url!
    }
}
