//
//  Theme.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import UIKit

enum Theme: UINavigationThemeProvider {
    
    case `default`
    
    // MARK: - UINavigationBar
    
    var navigationBarBackgroundColor: UIColor {
        return #colorLiteral(red: 0.2156862745, green: 0.1921568627, blue: 0.2980392157, alpha: 1)
    }
    
    var navigationBarTitleColor: UIColor {
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    var navigationBarTintColor: UIColor {
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    var navigationBarTitleFont: UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    
    var navigationBarBackButtonImage: UIImage {
        
        return UIImage()
    }
    
    var navigationBarShadowImage: UIImage {
        
        return UIImage()
    }
    
    var navigationBarTranslucent: Bool {
        
        return false
    }
    
    // MARK: - UITabBar
    
    var tabbarBackgroundColor: UIColor {
        return #colorLiteral(red: 0.1803921569, green: 0.1568627451, blue: 0.2549019608, alpha: 1)
    }
    
    var tabbarShadowImage: UIImage {
        return UIImage()
    }
    
    var tabbarSelectionIndicatorImage: UIImage {
        
        return UIImage()
    }
    
    var tabbarSelectedImageTintColor: UIColor {
        return #colorLiteral(red: 0.9960784314, green: 0.7215686275, blue: 0.2509803922, alpha: 1)
    }
    
    var statusBarHidden: Bool {
        
        return false
    }
    
    var statusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
    }
    
    // MARK: UIBarButtonItem
    
    var barButtonTextColorNormal: UIColor {
        
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    var barButtonTextColorHighlighted: UIColor {
        
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    var barButtonItemTextFont: UIFont {
        
        return UIFont.systemFont(ofSize: 15)
    }
    
    func setup() {
        
        UINavigationBar.configureAppearance(withTheme: self)
        UITabBar.configureAppearance(withTheme: self)
        Loader.configureAppearance()
        UIBarButtonItem.configureAppearance(withTheme: self)
    }
}
