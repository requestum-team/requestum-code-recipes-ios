//
//  NSError+Response.swift
//  Requestum
//
//  Created by Alex Kovalov on 5/1/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation
import CFNetwork

import Alamofire

fileprivate let kServerURLResponse = "kServerURLResponse"
fileprivate let kServerResponseData = "kServerResponseData"

extension NSError {
    
    var poorConectionError: Bool {
        
        let codes: Array = [
            CFNetworkErrors.cfurlErrorCancelled.rawValue,
            CFNetworkErrors.cfurlErrorTimedOut.rawValue,
            CFNetworkErrors.cfurlErrorCancelled.rawValue,
            CFNetworkErrors.cfurlErrorCannotFindHost.rawValue,
            CFNetworkErrors.cfurlErrorCannotConnectToHost.rawValue,
            CFNetworkErrors.cfurlErrorNetworkConnectionLost.rawValue,
            CFNetworkErrors.cfurlErrorDNSLookupFailed.rawValue,
            CFNetworkErrors.cfurlErrorResourceUnavailable.rawValue,
            CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue
        ]
        
        return codes.contains(Int32(self.code))
    }
    
    var hostUnavailableError: Bool {
        
        let codes: Array = [
            CFNetworkErrors.cfurlErrorTimedOut.rawValue,
            CFNetworkErrors.cfurlErrorCannotFindHost.rawValue,
            CFNetworkErrors.cfurlErrorCannotConnectToHost.rawValue,
            CFNetworkErrors.cfurlErrorResourceUnavailable.rawValue
        ]
        
        return codes.contains(Int32(self.code))
    }
    
    var HTTPResponseCode: Int? {
        
        return (userInfo[kServerURLResponse] as? HTTPURLResponse)?.statusCode
    }
    
    var responseErrorDescription: String? {
        
        if let data = userInfo[kServerResponseData] as? Data {
            do {
                if let JSON = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    
                    var errorString = JSON["error_description"] as? String
                    if errorString == nil {
                        errorString = JSON["error"] as? String
                    }
                    if errorString == nil {
                        errorString = JSON["Error"] as? String
                    }
                    if errorString == nil {
                        for key in JSON.keys {
                            if let errorDescription = (JSON[key] as? [String])?.first {
                                errorString = (errorString ?? "").isEmpty ? "" : (errorString! + "\n")
                                errorString = (errorString ?? "") + (key + ": " + errorDescription)
                            }
                        }
                    }
                    
                    return errorString
                }
            }
            catch (let error) {
                print(error)
            }
        }
        return nil
    }
    
    func with<T: Any>(dataResponse: DataResponse<T>) -> NSError {
        
        var newUserInfo = userInfo
        if let urlResponse = dataResponse.response {
            newUserInfo[kServerURLResponse] = urlResponse
        }
        if let serverData = dataResponse.data {
            newUserInfo[kServerResponseData] = serverData
        }
        return NSError(domain: domain, code: code, userInfo: newUserInfo)
    }
    
    var message: String? {
        
        return (userInfo[NSLocalizedRecoverySuggestionErrorKey] as? String) ?? userInfo[NSLocalizedDescriptionKey] as? String
    }
}


// MARK: Custom App Error

extension NSError {
    
    static func appError(withDescription description: String, code: Int = 0) -> NSError {
        
        return NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    static func appError(withResponseData data: Data, code: Int = 0) -> NSError {
        
        return NSError(domain: "", code: code, userInfo: [kServerResponseData: data])
    }
}


// MARK: - Refresh Token Error for request validation

fileprivate let kRefreshToken = "refreshToken"

extension NSError {
    
    static func refreshTokenError() -> NSError {
        
        return NSError(domain: "", code: 401, userInfo: [kRefreshToken: true])
    }
    
    func isRefreshTokenError() -> Bool {
        
        return userInfo[kRefreshToken] as? Bool == true
    }
}
