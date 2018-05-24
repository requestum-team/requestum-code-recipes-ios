//
//  ServerConstants.swift
//  Requestum
//
//  Created by Alex Kovalov on 3/28/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import UIKit

enum ServerAPI {
    
    enum Environment: String {
        
        case development
        case production
    }
    
    
    // MARK: - Auth
    
    case authToken
    case signUp
    case convertToken
    case user
    case changePassword
    case forgotPassword
    
    
    // MARK: - Event
    
    case events
    case eventsDetails(eventId: String)
    case eventsTweets(eventId: String)
    case getGooglePlaceApiKey
    
    
    var path: String {
        
        switch self {
            
        case .authToken:
            return "auth/token"
        case .signUp:
            return "accounts/register"
        case .convertToken:
            return "auth/convert-token"
        case .user:
            return "accounts/user"
        case .changePassword:
            return "accounts/change-password"
        case .forgotPassword:
            return "accounts/forgot-password"
            
        case .events:
            return "events"
        case .eventsDetails(let eventId):
            return "events/" + eventId
            
            
        default:
            return ""
        }
    }
    
    var fullURL: String {
        
        let baseUrl = ServerAPI.serverAPIUrl
        return baseUrl + path  + "/"
    }
    
    static var environment: Environment {
        
        guard let value = Bundle.main.object(forInfoDictionaryKey: "ServerEnvironment") as? String else {
            return .production
        }
        return Environment(rawValue: value) ?? .production
    }
    
    
    // MARK: - Auth
    
    struct Auth {
        
        static var clientId: String {
            switch ServerAPI.environment {
            case .development:
                return ""
            case .production:
                return ""
            }
        }
        
        static var clientSecret: String {
            switch ServerAPI.environment {
            case .development:
                return ""
            case .production:
                return ""
            }
        }
        
        static let grantType = "password"
    }
    
    static var baseUrl: String {
        
        switch ServerAPI.environment {
        case .development:
            return ""
        case .production:
            return ""
        }
    }
    
    static var baseSoketUrl: URL {
        
        switch ServerAPI.environment {
        case .development:
            return  URL(string: "")!
        case .production:
            return URL(string: "")!
        }
        
    }
    
    static let apiVer = "v1/"
    static let serverAPIUrl = baseUrl + "api/" + apiVer
}


struct URLLinks {
    
    static let terms = URL(string: "")!
    static let privacy = URL(string: "")!
}
