//
//  UIApplication+Bundle.swift
//  Requestum
//
//  Created by Alex Kovalov on 5/1/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    func appVersion() -> String {
        
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    func appName() -> String {
        
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
    
    func bundleVersion() -> String {
        
        return Bundle.main.infoDictionary![kCFBundleVersionKey as String] as! String
    }
    
    func documentsPath() -> String {
        
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    func bundleIdentifier() -> String {
        
        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    }
}
