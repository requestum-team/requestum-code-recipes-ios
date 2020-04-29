//
//  ValidatableTextField.swift
//  
//
//  Created by Alex Kovalov on 9/25/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import UIKit

final class ValidatableTextField: InsetableTextField {
    
    enum ValidationState {
        
        case none
        case valid
        case invalid(message: String)
    }
    
    @IBOutlet var messageLabel: UILabel?
    
    @IBInspectable var validBorderColor: UIColor?
    @IBInspectable var invalidBorderColor: UIColor?
    @IBInspectable var validationBorderWidth: CGFloat = 0
    
    var validationState: ValidationState = .none {
        didSet {
            updateValidationState()
        }
    }
    
    private var originalBorderColor: UIColor?
    private var originalBorderWidth: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let borderColor = layer.borderColor {
            originalBorderColor = UIColor(cgColor: borderColor)
        }
        originalBorderWidth = layer.borderWidth
        updateValidationState()
    }
    
    private func updateValidationState() {
        
        switch validationState {
        case .none:
            layer.borderColor = originalBorderColor?.cgColor
            layer.borderWidth = originalBorderWidth
            messageLabel?.isHidden = true
        case .invalid(let message):
            layer.borderColor = invalidBorderColor?.cgColor
            layer.borderWidth = validationBorderWidth
            messageLabel?.text = message
            messageLabel?.isHidden = false
        case .valid:
            layer.borderColor = originalBorderColor?.cgColor
            layer.borderWidth = originalBorderWidth
            messageLabel?.isHidden = true
        }
    }
}
