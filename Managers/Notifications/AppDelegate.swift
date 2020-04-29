//
//  AppDelegate.swift
//
//
//  Created by Alex Kovalov on 12.04.2020.
//  Copyright © 2020 Alex Kovalov. All rights reserved.
//

import UIKit
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        App.setup()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = App.navigator.initialViewController()
        window.makeKeyAndVisible()
        
        setupNotifications()
        RemoteNotificationsManager.shared.registerForRemoteNotifications()
        
        return true
    }
}

// MARK: - Notifications

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func setupNotifications() {
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        RemoteNotificationsManager.shared.applicationDidRegisterForRemoteNotifications(with: fcmToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        RemoteNotificationsManager.shared.handleNotification(notification)
        
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        RemoteNotificationsManager.shared.handleNotification(response.notification, actionIdentifier: response.actionIdentifier)
        
        completionHandler()
    }
}
