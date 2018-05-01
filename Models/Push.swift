//
//  Push.swift
//  Requestum
//
//  Created by Alex Kovalov on 3/3/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

import ObjectMapper

enum PushType: String {
    
    case any = ""
}

class Push: Mappable {
    
    // MARK: Properties
    
    var title: String?
    var alert: String?
    var type: String?
    var badge: Int?
    var data: [String: Any]?
    
    
    // MARK: Mappable
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        
        alert <- map["aps.alert"]
        if alert == nil { alert <- map["aps.alert.body"] }
        title <- map["aps.alert.title"]
        badge <- map["aps.badge"]
        
        type <- map["pn_type"]
        data <- map["data"]
    }
}
