//
//  Loader.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import UIKit
import SVProgressHUD

struct Loader {
    
    static func show() {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    static func show(with progress: Float) {
        DispatchQueue.main.async {
            SVProgressHUD.showProgress(progress)
        }
    }
    
    static func configureAppearance() {
        
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.2561911032, green: 0.5699472264, blue: 0.7631897842, alpha: 0.8009738116))
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        SVProgressHUD.setRingThickness(4.0)
    }
}
