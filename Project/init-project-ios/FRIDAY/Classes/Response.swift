//
//  Response.swift
//  FRIDAY
//
//  Created by Dima Hapich on 6/10/19.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation

public struct Response<Value, ErrorType: Error> {
    
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    public let data: Data?
    public let result: Result<Value, ErrorType>
    
    public init(request: URLRequest?, response: HTTPURLResponse?, data: Data?, result: Result<Value, ErrorType>) {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
    }
}
