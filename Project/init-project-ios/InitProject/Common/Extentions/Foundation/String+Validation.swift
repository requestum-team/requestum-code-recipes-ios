//
//  String+Validation.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation

extension String {
    
    var isEmail: Bool {
        
        return checkRegEx(for: self, regEx: "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,})$")
    }
    
    // MARK: - Private Methods
    
    private func checkRegEx(for string: String, regEx: String) -> Bool {
        
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        return test.evaluate(with: string)
    }
}
