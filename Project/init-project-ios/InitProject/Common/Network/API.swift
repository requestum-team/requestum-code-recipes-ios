//
//  API.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation
import FRIDAY
import Alamofire

enum API: String {
    
    case development
    case staging
    case production
    
    var baseURL: URL {
        
        switch self {
        case .development:
            return URL(string: "https://")!
        case .staging:
            return URL(string: "https://")!
        case .production:
            return URL(string: "https://")!
        }
    }
    
    var apiVersion: String {
        switch self {
        case .development:
            return "/v1"
        case .staging:
            return ""
        case .production:
            return ""
        }
    }
    
    var apiPath: String {
        switch self {
        case .development:
            return "/api\(self.apiVersion)"
        case .staging:
            return "/api\(self.apiVersion)"
        case .production:
            return "/api\(self.apiVersion)"
        }
    }
    
    var apiURL: URL {
        return baseURL
    }
    
    var clientID: String {
        switch self {
        case .development:
            return "0bef2c1f-2d28-4efd-9211-00241ed958cb"
        case .staging:
            return ""
        case .production:
            return ""
        }
    }
    
    var clientSecret: String {
        switch self {
        case .development:
            return "jLpOJ7S59U30MR9lPmAZmTktV4HGOcbXVYu7kVfYDKqpvN3S"
        case .staging:
            return ""
        case .production:
            return ""
        }
    }
    
    static var defaultTimeoutInterval: TimeInterval {
        return 20.0
    }
    
    func url(withPath path: String?) -> URL? {
        
        guard let path = path, !path.isEmpty else {
            return nil
        }
        
        return URL(string: path, relativeTo: baseURL)
    }
    
    fileprivate var basicAuthUser: String {
        switch self {
        case .development:
            return ""
        case .staging:
            return ""
        case .production:
            return ""
        }
    }
    
    fileprivate var basicAuthPassword: String {
        switch self {
        case .development:
            return ""
        case .staging:
            return ""
        case .production:
            return ""
        }
    }
    
    static func setup() {
        
        let URLCache = Foundation.URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: nil)
        Foundation.URLCache.shared = URLCache
        
        let configuration = URLSessionConfiguration.default
        configuration.networkServiceType = .default
        configuration.allowsCellularAccess = true
        configuration.httpShouldUsePipelining = true
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.timeoutIntervalForRequest = defaultTimeoutInterval
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            App.api.baseURL.host!: .performDefaultEvaluation(validateHost: true)
        ]
        
        let serverTrustPolicyManager = ServerTrustPolicyManager(policies: serverTrustPolicies)
        
        let manager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: serverTrustPolicyManager)
        
        Client.shared = Client(manager: manager)
    }
    
    var credential: URLCredential {
        return URLCredential(user: basicAuthUser, password: basicAuthPassword, persistence: .forSession)
    }
}

protocol APIRequestDataProvider: RequestDataProvider {}

extension APIRequestDataProvider {
    
    var baseUrl: FRIDAY.URLConvertible {
        
        return App.api.apiURL
    }
    
    var headers: HTTP.Headers? {
        
        if let token = App.userSession.accessToken {
            
            return ["Authorization": "Bearer \(token)"]
        }
        
        if let token = App.userSession.guestToken {
            
            return ["Authorization": "Bearer \(token)"]
        }
        
        return nil
    }
}

protocol APIParametersConvertible {
    func toParameters() -> Parameters
}
