//
//  SignUpData.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation

struct SignUpData {
    
    var email: String
    var password: String
    var confirmPassword: String
    
    init(with email: String, password: String, confirmPassword: String) throws {
        
        guard !email.isEmpty else {
            
            throw ValidationError.empty(.email)
        }
        guard email.isEmail else {
            
            throw ValidationError.invalid(.email)
        }
        
        guard !password.isEmpty else {
            
            throw ValidationError.empty(.password)
        }
        
        guard password.count >= 8 && password.count <= 24 else {
            
            throw ValidationError.invalid(.password)
        }
        
        guard !confirmPassword.isEmpty else {
            
            throw ValidationError.empty(.confirmPassword)
        }
        
        guard password == confirmPassword else {
            
            throw ValidationError.isNotMatch(.password, .confirmPassword)
        }
        
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }
}
