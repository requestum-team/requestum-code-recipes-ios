//
//  App.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
import Rswift
import FRIDAY
import Firebase

struct App {
    
    static let api: API = {
        
        guard let value = Bundle.main.object(forInfoDictionaryKey: "ServerEnvironment") as? String else {
            return .development
        }
        return API(rawValue: value) ?? .development
    }()
    
    static let navigator = AppNavigator()
    static let userSession = ClientUserSession()
    static let theme = Theme.default
    
    static func setup() {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    
        App.theme.setup()
    
        FirebaseApp.configure()
        
        FRIDAY.isLoggingEnabled = true
    }
    
    static func logout() {
        
        do {
            try userSession.deactivate()
        } catch {
            print(error.localizedDescription) // TODO: Add error handling
        }
        navigator.setInitialViewController()
    }
}
