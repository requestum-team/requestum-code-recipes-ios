//
//  App.swift
//  Requestum
//
//  Created by Alex Kovalov on 3/26/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

import Fabric
import Crashlytics
import IQKeyboardManagerSwift

/*
 Setup third party services and common app stuff.
 ```
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
 
    App.setup()
 
    return true
 }
 ```
 */
struct App {
    
    static func setup() {
        
        Fabric.with([Crashlytics.self])
        IQKeyboardManager.shared.enable = true
    }
    
    static func logout() {
        
        Token.token = nil
        User.currentUser = nil
    }
}
