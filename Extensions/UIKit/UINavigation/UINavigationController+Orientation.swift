//
//  UINavigationController+Orientation.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return topViewController?.supportedInterfaceOrientations ?? App.theme.supportedInterfaceOrientations
    }
    
    open override var shouldAutorotate: Bool {
        
        return topViewController?.shouldAutorotate ?? true
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return topViewController?.preferredStatusBarStyle ?? App.theme.statusBarStyle
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        
        return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}
