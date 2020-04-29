//
//  RemoteNotificationsManager+Push.swift
//
//
//  Created by Alex Kovalov on 28.04.2020.
//  Copyright © 2020 Alex Kovalov. All rights reserved.
//

import Foundation
import UIKit

extension RemoteNotificationsManager {
    
    func handlePush(with json: [String: Any], actionIdentifier: String?) -> Push? {
        
        guard let aps = json["aps"], let data = try? JSONSerialization.data(withJSONObject: aps, options: .prettyPrinted) else {
            return nil
        }
        
        guard let push = try? JSONDecoder().decode(Push.self, from: data) else {
            return nil
        }
        
        // handle push if needed
        
        return push
    }
}
