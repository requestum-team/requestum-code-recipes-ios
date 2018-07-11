//
//  KeyboardEventsHandler.swift
//
//
//  Created by Dima hapich on 5/31/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import UIKit

public class KeyboardEventsHandler: NSObject {
    
    private weak var viewConstraint: NSLayoutConstraint?
    private var originalConstant: CGFloat = 0.0
    private weak var animatedView: UIView?
    private var keyboardIsPresent: Bool = false
    private var offsetForView: CGFloat = 0.0
    
    public var completion: ((Bool) -> Void)?
    
    public convenience init(constraint: NSLayoutConstraint, forView: UIView, withOffset offset: CGFloat = 0) {
        self.init()
        
        viewConstraint = constraint
        originalConstant = constraint.constant
        animatedView = forView
        offsetForView = offset
        
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func handleConstraint(with notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                
                let newConstant = originalConstant + keyboardHeight + offsetForView
                
                if viewConstraint?.constant != newConstant {
                    viewConstraint?.constant = newConstant
                    
                    let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                    
                    UIView.animate(withDuration: duration) { [weak self] in
                        self?.animatedView?.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    @objc
     public func keyboardWillShow(notification: NSNotification) {
        
        if keyboardIsPresent == false {
            
            handleConstraint(with: notification)
            
        }
    }
    
    @objc
     public func keyboardDidShow(notification: NSNotification) {
        
        keyboardIsPresent = true
        
        if let completion = completion {
            completion(keyboardIsPresent)
        }
    }
    
    @objc
     public func keyboardWillHide(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            if viewConstraint?.constant != originalConstant {
                viewConstraint?.constant = originalConstant
                
                let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                
                UIView.animate(withDuration: duration) { [weak self] in
                    self?.animatedView?.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc
     public func keyboardDidHide(notification: NSNotification) {
        keyboardIsPresent = false
    }
    
    @objc
     public func keyboardWillChangeFrame(notification: NSNotification) {
        
        if keyboardIsPresent == true {
            
            handleConstraint(with: notification)
        }
    }
}
