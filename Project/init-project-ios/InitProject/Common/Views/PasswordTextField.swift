//
//  PasswordTextField.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import UIKit

class PasswordTextField: UITextField {
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isSecureTextEntry = true
        setupView()
    }
    
    @objc
    private func toggleSecureEntry(_ sender: UIButton) {
        isSecureTextEntry = !isSecureTextEntry
        sender.isSelected = !sender.isSelected
    }
    
    func setupView() {
        
        rightViewMode = .always
        let rightItem = UIButton(frame: CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height))
//        rightItem.setImage(R.image.eye(), for: .normal)
//        rightItem.setImage(R.image.eye(), for: .selected)
        rightItem.addTarget(self, action: #selector(toggleSecureEntry), for: .touchUpInside)
        
        rightView = rightItem
        
    }
}
