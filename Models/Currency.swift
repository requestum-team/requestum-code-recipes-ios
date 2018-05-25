//
//  Currency.swift
//  Requestum
//
//  Created by Alex Kovalov on 1/31/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

class Currency: Object, Mappable {
    
    // MARK: Properties
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String?
    
    
    // MARK: Lifecycle
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    // MARK: Mappable
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
    }
}
