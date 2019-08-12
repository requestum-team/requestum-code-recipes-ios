//
//  UserSession.swift
//
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation
import KeychainAccess
import Default


public protocol UserSessionActivationData {
    
    var accessToken: String { get }
    var expiresIn: Int { get }
    var tokenType: String { get }
    var refreshToken: String { get }
}


public protocol UserSession: class {
    
    var isActive: Bool { get }
    var accessToken: String? { get }
    var refreshToken: String? { get }
    var currentUser: User? { get set }
    
    func activate(with data: UserSessionActivationData) throws
    func deactivate() throws
}


final class ClientUserSession: UserSession {
    
    var onActivation: (() -> Void)?
    var onDeactivation: (() -> Void)?
    
    fileprivate enum Keys: String {
        
        case accessToken = "accessToken"
        case guestToken = "guestToken"
        case updateToken = "updateToken"
        case refreshToken = "refreshToken"
        case isAuthorizeKey = "authorize"
        case currentUser = "currentUser"
    }
    
    fileprivate let defaults = UserDefaults.standard
    fileprivate let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    var currentUser: User? {
        
        set {
            defaults.df.store(newValue, forKey: Keys.currentUser.rawValue)
            defaults.synchronize()
        }
        
        get {
            return defaults.df.fetch(forKey: Keys.currentUser.rawValue, type: User.self)
        }
    }
    
    var accessToken: String? {
        return keychain[Keys.accessToken.rawValue]
    }
    
    var guestToken: String? {
        return keychain[Keys.guestToken.rawValue]
    }
    
    var updateToken: String? {
        return keychain[Keys.updateToken.rawValue]
    }
    
    var refreshToken: String? {
        return keychain[Keys.refreshToken.rawValue]
    }
    
    fileprivate var authorized: Bool {
        
        return defaults.bool(forKey: Keys.isAuthorizeKey.rawValue)
    }
    
    var isActive: Bool {
        
        return authorized && accessToken != nil
    }
    
    func setGuestToken(with data: UserSessionActivationData) throws {
        
        do {
            try keychain
                .accessibility(.always)
                .synchronizable(false)
                .set(data.accessToken, key: Keys.guestToken.rawValue)
            
        } catch let error {
            throw error
        }
    }
    
    func setUpdateToken(_ token: String) throws {
        
        do {
            try keychain
                .accessibility(.always)
                .synchronizable(false)
                .set(token, key: Keys.updateToken.rawValue)
            
        } catch let error {
            throw error
        }
    }
    
    func activate(with data: UserSessionActivationData) throws {
        
        do {
            
            try keychain
                .accessibility(.always)
                .synchronizable(false)
                .set(data.accessToken, key: Keys.accessToken.rawValue)
            
            try keychain
                .accessibility(.always)
                .synchronizable(false)
                .set(data.refreshToken, key: Keys.refreshToken.rawValue)
            
            try? keychain.remove(Keys.guestToken.rawValue)
            
            defaults.set(true, forKey: Keys.isAuthorizeKey.rawValue)
            defaults.synchronize()
            
        } catch let error {
            throw error
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.onActivation?()
        }
    }
    
    func deactivate() throws {
        
        do {
            try keychain.remove(Keys.accessToken.rawValue)
            try keychain.remove(Keys.refreshToken.rawValue)
            try? keychain.remove(Keys.guestToken.rawValue)
            try? keychain.remove(Keys.updateToken.rawValue)
            
            defaults.set(false, forKey: Keys.isAuthorizeKey.rawValue)
            defaults.removeObject(forKey: Keys.currentUser.rawValue)
            defaults.synchronize()
            DispatchQueue.main.async { [unowned self] in
                self.onDeactivation?()
            }
        } catch let error {
            throw error
        }
    }
}
