//
//  UIBarButtonItem+Appearance.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import UIKit


extension UIBarButtonItem: UINavigationAppearanceConfigurable {
    
    static func configureAppearance(withTheme theme: UINavigationThemeProvider) {
        
        let appearance = self.appearance()
        
        appearance.setTitleTextAttributes([.font: theme.barButtonItemTextFont, .foregroundColor: theme.barButtonTextColorNormal], for: .normal)
        appearance.setTitleTextAttributes([.font: theme.barButtonItemTextFont, .foregroundColor: theme.barButtonTextColorHighlighted], for: .highlighted)
    }
}
