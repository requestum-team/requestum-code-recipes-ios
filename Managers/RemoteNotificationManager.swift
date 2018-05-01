//
//  RemoteNotificationsManager.swift
//  Requestum
//
//  Created by Alex Kovalov on 5/1/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation
import UIKit

import ObjectMapper
import UserNotifications

fileprivate let kDeviceToken = "kDeviceToken"

let AppDidReceivePushNotification = NSNotification.Name(rawValue: "AppDidReceivePushNotification")
let AppDidRegisterForPushNotificationsNotification = NSNotification.Name(rawValue: "AppDidRegisterForPushNotificationsNotification")

class RemoteNotificationsManager: NSObject {
    
    static let shared = RemoteNotificationsManager()
    
    
    // MARK: Properties
    
    var deviceToken: String? {
        get { return UserDefaults.standard.string(forKey: kDeviceToken) }
        set { UserDefaults.standard.set(newValue, forKey: kDeviceToken) }
    }
    
    
    // MARK: Actions
    
    func registerForRemoteNotifications(authorizationCompletion: @escaping (_ authorized: Bool) -> Void) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (success, error) in
            
            DispatchQueue.main.async {
                
                self.getRemoteNotificationsAuthorized(authorizationCompletion)
                
                if success {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func getRemoteNotificationsAuthorized(_ completion: @escaping (_ authorized: Bool) -> Void) {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            let authorized = settings.authorizationStatus == .authorized
            
            DispatchQueue.main.async {
                completion(authorized)
            }
        }
    }
    
    func applicationDidRegisterForRemoteNotifications(with deviceToken: Data) {
        
        self.deviceToken = stringFromData(data: deviceToken)
        
        NSLog("APNS TOKEN: %@", self.deviceToken ?? "")
        
        NotificationCenter.default.post(name: AppDidRegisterForPushNotificationsNotification, object: nil)
    }
    
    func handleRemoteNotification(userInfo: [AnyHashable : Any], actionIdent: String? = nil) {
        
        guard let push = Mapper<Push>().map(JSON: userInfo as! [String : Any]) else {
            return
        }
        
        handlePush(push: push)
        
        NotificationCenter.default.post(name: AppDidReceivePushNotification, object: push)
    }
}


// MARK: - Helpers

extension RemoteNotificationsManager {
    
    func stringFromData(data: Data) -> String {
        
        var str = (data as NSData).description.replacingOccurrences(of: " ", with: "")
        str = str.replacingOccurrences(of: "<", with: "")
        str = str.replacingOccurrences(of: ">", with: "")
        
        return str
    }
}
