//
//  RemoteNotificationsManager.swift
//
//
//  Created by Alex Kovalov on 28.04.2020.
//  Copyright © 2020 Alex Kovalov. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

extension NSNotification.Name {
    
    static let didReceiveRemoteNotification = NSNotification.Name(rawValue: "didReceiveRemoteNotification")
    static let didRegisterForRemoteNotification = NSNotification.Name(rawValue: "didRegisterForRemoteNotification")
}

final class RemoteNotificationsManager: NSObject {
    
    static let shared = RemoteNotificationsManager()
    
    // MARK: Properties
    
    private let kDeviceToken = "kDeviceToken"
    var deviceToken: String? {
        get { return UserDefaults.standard.string(forKey: kDeviceToken) }
        set { UserDefaults.standard.set(newValue, forKey: kDeviceToken) }
    }
    
    // MARK: Actions
    
    func registerForRemoteNotifications() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { success, _ in
            
            DispatchQueue.main.async {
                if success {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func getRemoteNotificationsAuthorized(_ completion: @escaping (_ authorized: Bool) -> Void) {
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            let authorized = settings.authorizationStatus == .authorized
            
            DispatchQueue.main.async {
                
                completion(authorized)
            }
        }
    }
    
    func applicationDidRegisterForRemoteNotifications(with deviceToken: String) {
        
        self.deviceToken = deviceToken
        NotificationCenter.default.post(name: .didRegisterForRemoteNotification, object: nil)
        
        NSLog("APNS TOKEN: %@", self.deviceToken ?? "")
    }
    
    func handleNotification(_ notification: UNNotification, actionIdentifier: String? = nil) {
        
        let userInfo = notification.request.content.userInfo
        
        guard let json = userInfo as? [String: Any] else {
            return
        }
        let push = handlePush(with: json, actionIdentifier: actionIdentifier)
        
        NotificationCenter.default.post(name: .didReceiveRemoteNotification, object: push)
    }
    
}
