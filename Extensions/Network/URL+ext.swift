//
//  URL+ext.swift
//  Requestum
//
//  Created by Alex Kovalov on 1/4/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation

extension URL {
    
    var parameters: [String: String] {
        
        var dict = [String: String]()
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        
        if let queryItems = components?.queryItems {
            
            for item in queryItems {
                dict[item.name] = item.value
            }
        }
        
        return dict
    }
}
