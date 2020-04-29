//
//  InsatableTextField.swift
//  
//
//  Created by Alex Kovalov on 8/13/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import UIKit

class InsetableTextField: UITextField {
    
    var textRectInsets: UIEdgeInsets = .zero
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textRectInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textRectInsets)
    }
}
