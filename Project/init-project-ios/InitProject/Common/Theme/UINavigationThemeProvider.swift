//
//  UINavigationThemeProvider.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import UIKit

protocol UINavigationThemeProvider {
    
    // MARK: - navigationBar
    
    var navigationBarBackgroundColor: UIColor { get }
    var navigationBarTitleColor: UIColor { get }
    var navigationBarTintColor: UIColor { get }
    var navigationBarTitleFont: UIFont { get }
    var navigationBarBackButtonImage: UIImage { get }
    var navigationBarShadowImage: UIImage { get }
    var navigationBarTranslucent: Bool { get }
    
    // MARK: - Tabbar
    
    var tabbarBackgroundColor: UIColor { get }
    var tabbarShadowImage: UIImage { get }
    var tabbarSelectionIndicatorImage: UIImage { get }
    var tabbarSelectedImageTintColor: UIColor { get }
    
    // MARK: - UIBarButtonItem
    
    var barButtonItemTextFont: UIFont { get }
    var barButtonTextColorNormal: UIColor { get }
    var barButtonTextColorHighlighted: UIColor { get }
    
    // MARK: - Status bar
    
    var statusBarHidden: Bool { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var supportedInterfaceOrientations: UIInterfaceOrientationMask { get }
    
    func setup()
    func setupNavigationBar(_ navigationBar: UINavigationBar)
}

extension UINavigationThemeProvider {
    
    func setupNavigationBar(_ navigationBar: UINavigationBar) {
        
        navigationBar.tintColor = navigationBarTintColor
        navigationBar.barTintColor = navigationBarBackgroundColor
        navigationBar.shadowImage = navigationBarShadowImage
        navigationBar.isTranslucent = navigationBarTranslucent
        navigationBar.titleTextAttributes = [
            .foregroundColor: navigationBarTitleColor,
            .font: navigationBarTitleFont
        ]
        
        navigationBar.backIndicatorImage = navigationBarBackButtonImage
        navigationBar.backIndicatorTransitionMaskImage = navigationBarBackButtonImage
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}

protocol UINavigationAppearanceConfigurable {
    static func configureAppearance(withTheme theme: UINavigationThemeProvider)
}
