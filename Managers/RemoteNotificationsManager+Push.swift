//
//  RemoteNotificationsManager+Push.swift
//  Requestum
//
//  Created by Alex Kovalov on 5/1/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

extension RemoteNotificationsManager {
    
    func handlePush(push: Push) {
        
        //        let openedFromPush = UIApplication.shared.applicationState == .inactive
        
        let type = push.type ?? ""
        switch type {
            
        default:
            let text = push.alert ?? "Push notification"
            AlertsManager.showAlert(message: text)
        }
    }
}
