//
//  String+Trimming.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation

extension String {
    
    func trimmed() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
