//
//  UsersQuery.swift
//
//
//  Created by Alex Kovalov on 9/18/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation

class UsersQuery: APIQuery {
    
    var email: String?
    
    private enum CodingKeys: String, CodingKey {
        
        case email
    }
    
    override func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(email, forKey: .orderemailBy)
        
        try super.encode(to: encoder)
    }
}
