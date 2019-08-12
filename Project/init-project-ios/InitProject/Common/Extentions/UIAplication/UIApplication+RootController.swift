//
//  UIApplication+RootController.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static func setRootViewController(_ controller: UIViewController?, inWindow window: UIWindow? = UIApplication.shared.keyWindow, animated: Bool) {
        
        if let window = window, let controller = controller {
            
            if animated {
                UIView.transition(with: window, duration: 0.1, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = controller
                }, completion: nil)
            } else {
                window.rootViewController = controller
            }
        }
    }
    
    static func rootViewController() -> UIViewController? {
        
        return UIApplication.shared.keyWindow?.rootViewController
    }
}
