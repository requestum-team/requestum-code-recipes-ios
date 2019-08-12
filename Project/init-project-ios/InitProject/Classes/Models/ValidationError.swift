//
//  ValidationError.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation

enum ValidatableAttribute: String {
    
    case firstName
    case lastName
    case email
    case confirmEmail
    case password
    case confirmPassword
}

enum ValidationError: Error {
    
    case empty(_: ValidatableAttribute)
    case invalid(_: ValidatableAttribute)
    case isMatch(_: ValidatableAttribute, ValidatableAttribute)
    case isNotMatch(_: ValidatableAttribute, ValidatableAttribute)
    
    var message: String {
        
        switch self {
        case .empty(let attribute):
            return "Empty \(attribute)"
        case .invalid(let attribute):
            return "Invalid \(attribute)"
        case .isMatch(let firstAttribute, let secondAttribute):
            return "\(firstAttribute), \(secondAttribute)"
        case .isNotMatch(let firstAttribute, let secondAttribute):
            return "\(firstAttribute), \(secondAttribute)"
        }
    }
}
