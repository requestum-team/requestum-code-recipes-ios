//
//  String+Validation.swift
//  Requestum
//
//  Created by Dima Hapich on 2/13/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

extension String {
    
    var isEmail: Bool {
        
        return checkRegEx(for: self, regEx: "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,})$")
    }
    
    fileprivate func checkRegEx(for string: String, regEx: String) -> Bool {
        
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        return test.evaluate(with: string)
    }
    
    func trimmed() -> String {
        
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
