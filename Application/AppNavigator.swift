//
//  AppNavigator.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import UIKit

struct AppNavigator {
    
    func initialViewController() -> UIViewController {
        
//        guard let user = App.userSession.currentUser else {
//            return R.storyboard.auth.signInViewController()!
//        }
//
//        return R.storyboard.main.instantiateInitialViewController()!
        return UIViewController()
    }
    
    func setInitialViewController(animation: Bool = false) {
        
        UIApplication.setRootViewController(initialViewController(), animated: true)
    }
}
