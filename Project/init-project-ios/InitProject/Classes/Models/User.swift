//
//  User.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation

public struct User {
    
    var identifier: Int
}


// MARK: - Codable

extension User: Codable {
    
    enum Keys: String, CodingKey {
        
        case identifier = "id"
    }
}
