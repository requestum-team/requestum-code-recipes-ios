//
//  SignInData.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation

struct SignInData {
    
    enum Attribute: ValidatableAttribute {
        
        case email
        case password
        
        var title: String {
            switch self {
            case .email:
                return R.string.login.userIdTextFieldPlaceholder()
            case .password:
                return R.string.login.passwordTextFieldPlaceholder()
            }
        }
    }
    
    var userId: String
    var password: String
    
    init(with userId: String, password: String) throws {
        
        guard !userId.isEmpty else {
            throw ValidationError.empty(Attribute.email)
        }
        guard !password.isEmpty else {
            throw ValidationError.empty(Attribute.password)
        }
        
        self.userId = userId
        self.password = password
    }
}
