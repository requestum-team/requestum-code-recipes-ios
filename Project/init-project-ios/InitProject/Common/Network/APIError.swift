//
//  APIError.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation
import FRIDAY

enum APIError: ResponseError {
    
    enum CustomError: String {
        
        case `default` = "Unexpected error"
    }
    
    case parsingFailed
    case noInternetConnection
    case networkError(HTTP.StatusCode, message: String?, customError: CustomError)
    case failure(message: String?)
    
    var statusCode: HTTP.StatusCode? {
        
        switch self {
        case .networkError(let statusCode, _, _):
            return statusCode
        default:
            return nil
        }
    }
    
    var message: String? {
        
        switch self {
        case .parsingFailed:
            return R.string.network.errorParsingFailed()
        case .noInternetConnection:
            return R.string.network.errorNoInternetConnection()
        case .failure(let message):
            return message
        case .networkError(let statusCode, let message, _):
            
            if let message = message {
                return message
            } else {
                switch statusCode {
                case .unauthorized:
                    return R.string.network.errorUnauthorized()
                case .notFound:
                    return R.string.network.errorNotFound()
                case .internalServerError:
                    return R.string.network.errorInternalServerError()
                default:
                    return R.string.network.errorInternalServerError()
                }
            }
        }
    }
    
    init(response: HTTPURLResponse?, data: Data?, error: Error?) {
        
        if let error = error as NSError? {
            
            if error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                self = .noInternetConnection
                return
            } else {
                self = .failure(message: error.localizedDescription)
                return
            }
        }
        
        guard let httpResponse = response, let statusCode = HTTP.StatusCode(rawValue: httpResponse.statusCode) else {
            self = .parsingFailed
            return
        }
        
        switch statusCode {
        case .unauthorized:
            break
        default:
            break
        }
        
        let message: String? = errorMessage(for: response, data: data, error: error)
        
        self = .networkError(statusCode, message: message, customError: .default)
    }
    
    init(message: String) {
        
        self = .networkError(.multiStatus, message: message, customError: .default)
    }
}

private func errorMessage(for response: HTTPURLResponse?, data: Data?, error: Error?) -> String? {
    
    
    guard  let json = data, let entity = String(data: json, encoding: String.Encoding.utf8) else {
        
        return "Can't parse"
    }
    return entity
}
