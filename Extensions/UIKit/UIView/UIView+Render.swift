//
//  UIView+Render.swift
//  Requestum
//
//  Created by Alex Kovalov on 4/14/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func asImage() -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
