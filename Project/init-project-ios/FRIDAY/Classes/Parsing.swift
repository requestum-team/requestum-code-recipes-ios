//
//  Parsing.swift
//  FRIDAY
//
//  Created by Dima Hapich on 6/10/19.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation

public protocol ResponseParsing {
    
    associatedtype Parsable
    associatedtype ParsingError: Error
    
    func parse(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) -> Result<Parsable, ParsingError>
}

public struct ResponseParser<Value, ErrorType: Error>: ResponseParsing {
    
    public typealias Parsable = Value
    public typealias ParsingError = ErrorType
    
    private var parseResponseHandler: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Result<Parsable, ParsingError>
    
    public init(parseResponseHandler: @escaping (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Result<Parsable, ParsingError>) {
        self.parseResponseHandler = parseResponseHandler
    }
    
    public func parse(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) -> Result<Parsable, ParsingError> {
        return parseResponseHandler(request, response, data, error)
    }
}
