//
//  UINavigationBar+Appearance.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import UIKit

extension UINavigationBar: UINavigationAppearanceConfigurable {
    
    static func configureAppearance(withTheme theme: UINavigationThemeProvider) {
        
        let appearance = self.appearance()
        
        appearance.isTranslucent = theme.navigationBarTranslucent
        appearance.tintColor = theme.navigationBarTintColor
        appearance.barTintColor = theme.navigationBarBackgroundColor
        appearance.shadowImage = theme.navigationBarShadowImage
        appearance.titleTextAttributes = [
            .foregroundColor: theme.navigationBarTitleColor,
            .font: theme.navigationBarTitleFont
        ]
        
        appearance.backIndicatorImage = theme.navigationBarBackButtonImage
        appearance.backIndicatorTransitionMaskImage = theme.navigationBarBackButtonImage
    }
}
