//
//  Token.swift
//  Requestum
//
//  Created by Alex Kovalov on 2/23/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

import ObjectMapper

public class Token: Mappable {
    
    // MARK: Properties
    
    var accessToken: String?
    var tokenType: String?
    var expiresIn: Int?
    var refreshToken: String?
    var scope: String?
    
    fileprivate static let kCurrentToken = "currentToken"
    fileprivate static let kGuestToken = "guestToken"
    
    
    // MARK: Mappable
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        
        accessToken <- map["access_token"]
        tokenType <- map["token_type"]
        expiresIn <- map["expires_in"]
        refreshToken <- map["refresh_token"]
        scope <- map["scope"]
    }
}


// MARK: Helpers

extension Token {
    
    static var token: Token? {
        get {
            return DataSource.mappable()
        }
        set {
            DataSource.setMappable(newValue)
        }
    }
}
