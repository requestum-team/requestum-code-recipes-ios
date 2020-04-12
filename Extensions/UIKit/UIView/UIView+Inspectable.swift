//
//  UIView+Inspectable.swift
//  Requestum
//
//  Created by Alex Kovalov on 5/1/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    
    @IBInspectable var borderColor: UIColor? {
        
        set { layer.borderColor = newValue?.cgColor }
        get { return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : nil }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        
        set {
            layer.masksToBounds = false
            layer.shadowRadius = newValue
        }
        get { return layer.shadowRadius }
    }
    
    @IBInspectable var shadowOpacity: Float {
        
        set {
            layer.masksToBounds = false
            layer.shadowOpacity = newValue
        }
        get { return layer.shadowOpacity }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        
        set {
            layer.masksToBounds = false
            layer.shadowColor = newValue?.cgColor
        }
        get { return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : nil }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        
        set {
            layer.masksToBounds = false
            layer.shadowOffset = newValue
        }
        get { return layer.shadowOffset }
    }
}

