//
//  UIApplication+TopViewController.swift
//  Requestum
//
//  Created by Dima Hapich on 3/19/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import UIKit

extension UIApplication {
    
    public static func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = base as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        
        if let tabbarController = base as? UITabBarController {
            
            if let selected = tabbarController.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
        return base
    }
}

