//
//  Push.swift
//
//
//  Created by Alex Kovalov on 28.04.2020.
//  Copyright © 2020 Alex Kovalov. All rights reserved.
//

import Foundation

struct Push: Decodable {
    
    // MARK: Properties
    
    var alert: APSAlert?
    var badge: Int?
    
    enum CodingKeys: String, CodingKey {
        case alert
        case badge
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        alert = try? container.decode(APSAlert.self, forKey: .alert)
        if alert == nil, let alertBody = try? container.decode(String.self, forKey: .alert) {
            alert = APSAlert(title: nil, body: alertBody, subtitle: nil)
        }
        badge = try? container.decode(Int.self, forKey: .badge)
    }
}

struct APSAlert: Codable {
    
    var title: String?
    var body: String?
    var subtitle: String?
}
