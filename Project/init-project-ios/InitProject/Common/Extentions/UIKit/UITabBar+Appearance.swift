//
//  UITabBar+Appearance.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import UIKit

extension UITabBar: UINavigationAppearanceConfigurable {
    
    static func configureAppearance(withTheme theme: UINavigationThemeProvider) {
        
        let appearance = self.appearance()
        
        appearance.barTintColor = theme.tabbarBackgroundColor
        appearance.shadowImage = theme.tabbarShadowImage
        appearance.backgroundImage = UIImage()
        appearance.selectionIndicatorImage = theme.tabbarSelectionIndicatorImage
        appearance.isTranslucent = false
        appearance.itemSpacing = 0.0
        appearance.tintColor = theme.tabbarSelectedImageTintColor
    }
}
