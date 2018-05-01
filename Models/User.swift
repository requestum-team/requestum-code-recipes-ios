//
//  User.swift
//  Requestum
//
//  Created by Alex Kovalov on 3/26/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

import ObjectMapper

public class User: Mappable {
    
    // MARK: - Properties
    
    var id: Int?
    var email: String?
    
    
    // MARK: - Mappable
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        
        id <- map["id"]
        email <- map["email"]
    }
}


// MARK: - Helpers

extension User {
    
    static var currentUser: User? {
        get {
            return DataSource.mappable()
        }
        set {
            DataSource.setMappable(newValue)
        }
    }
}
