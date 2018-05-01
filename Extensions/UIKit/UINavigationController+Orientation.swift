//
//  UINavigationController+Orientation.swift
//  Requestum
//
//  Created by Dima Hapich on 3/21/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    open override var shouldAutorotate: Bool {
        
        return topViewController?.shouldAutorotate ?? true
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        
        return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
}
