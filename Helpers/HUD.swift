//
//  HUD.swift
//  Requestum
//
//  Created by Alex Kovalov on 3/25/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

import JGProgressHUD

class HUD {
    
    var typedHUD: JGProgressHUD?
    
    static let dismissAfter = 2.0
    
    @discardableResult
    class func show(text: String? = nil, in view: UIView, dismissAutomatically: Bool = false) -> HUD {
        
        let hud = HUD()
        
        let typedHUD = JGProgressHUD(style: .dark)
        typedHUD.textLabel.text = text
        typedHUD.show(in: view, animated: true)
        
        if dismissAutomatically {
            typedHUD.dismiss(afterDelay: dismissAfter)
        }
        
        hud.typedHUD = typedHUD
        
        return hud
    }
    
    func dismiss() {
        
        typedHUD?.dismiss(animated: true)
    }
}
