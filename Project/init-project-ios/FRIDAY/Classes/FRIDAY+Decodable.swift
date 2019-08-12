//
//  FRIDAY+Decodable.swift
//  FRIDAY
//
//  Created by Dima Hapich on 6/10/19.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation

public class JSONResponseParser<ParsedValue: Decodable, ErrorType: ResponseError>: ResponseParsing {
    
    public typealias Parsable = ParsedValue
    public typealias ParsingError = ErrorType
    
    public init () {}
    
    public func parse(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) -> Result<Parsable, ParsingError> {
        
        guard error == nil else {
            return .failure(ErrorType(response: response, data: data, error: error))
        
        }
        
        if isLoggingEnabled, let json = data, let jsonString = String(data: json, encoding: String.Encoding.utf8) {
            
            print("Data:")
            if jsonString.isEmpty {
                print("\nEmpty\n")
            } else {
                print("\n\(jsonString)\n")
            }
        }
       
        // TODO: add check type for Parsable is Optional<>
        if Parsable.self == Data?.self {
            
            if let json = data, let entity = try? JSONDecoder().decode(Parsable.self, from: json) {
                return .success(entity)
            } else if let entity = (try? JSONDecoder().decode(Parsable.self, from: Data())) as? Parsable {
                return .success(entity)
            } else {
                return .failure(ErrorType(response: response, data: data, error: error))
            }
        }
        
        guard let json = data, let entity = try? JSONDecoder().decode(Parsable.self, from: json) else {
            
            return .failure(ErrorType(response: response, data: data, error: error))
        }
        
        return .success(entity)
        
    }
}

extension Request {
    
    @discardableResult
    public func responseJSON<Parsable: Decodable, ErrorType: ResponseError>(
        completeOn queue: DispatchQueue = .main,
        completion: @escaping (Response<Parsable, ErrorType>) -> Void) -> Self {
        
        return response(completeOn: queue, using: JSONResponseParser<Parsable, ErrorType>(), completion: completion)
    }
}
