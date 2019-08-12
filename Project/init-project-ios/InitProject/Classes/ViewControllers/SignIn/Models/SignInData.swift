//
//  SignInData.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation

struct SignInData {
    
    var email: String
    var password: String
    
    init(with email: String, password: String) throws {
        
        guard !email.isEmpty else {
            
            throw ValidationError.empty(.email)
        }
        
        guard !password.isEmpty else {
            
            throw ValidationError.empty(.password)
        }
        
        self.email = email
        self.password = password
    }
}
