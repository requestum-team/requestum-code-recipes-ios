//
//  AlertsManager.swift
//  Requestum
//
//  Created by Alex Kovalov on 9/1/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation
import UIKit

class AlertsManager: NSObject {
    
    typealias PopoverConfig = (sourceView: UIView?, sourceRect: CGRect?, barButtonItem: UIBarButtonItem?)
    
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    
    static var viewControllerToPresentFrom: UIViewController? {
        
        return UIApplication.topViewController()
    }
    
    static var viewToShowOn: UIView? {
        
        return viewControllerToPresentFrom?.view
    }
    
    
    // MARK: - Actions
    
    static func userFriendlyMessage(for error: NSError?) -> String {
        
        var message = "Unknown error"
        if error != nil {
            if let errorDescription = error?.responseErrorDescription {
                return errorDescription
            }
            message = error!.localizedDescription
            if message.isEmpty {
                if let recovery = error!.localizedRecoverySuggestion {
                    return recovery
                }
            }
        }
        return message
    }
    
    static func showErrorWithAlert(with error: NSError?) {
        
        let message = userFriendlyMessage(for: error)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewControllerToPresentFrom?.present(alert, animated: true, completion: nil)
    }
    
    static func showError(with message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewControllerToPresentFrom?.present(alert, animated: true, completion: nil)
    }
    
    
    static func showAlert(withTitle title: String? = nil , message: String? = nil, actions: [UIAlertAction]? = nil, style: UIAlertControllerStyle = .alert) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        if actions != nil {
            for action in actions! {
                alert.addAction(action)
            }
        }
        else {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        viewControllerToPresentFrom?.present(alert, animated: true, completion: nil)
    }
    
    static func showConfirmationAlert(withTitle title: String? = nil, message: String? = nil, confirmTitle: String,  style: UIAlertActionStyle = .default, confirmHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: confirmTitle, style: style, handler: { action in
            
            confirmHandler()
        }))
        
        viewControllerToPresentFrom?.present(alert, animated: true, completion: nil)
    }
    
    static func showTextFieldAlert(withTitle title: String? = nil, message: String? = nil, initialText: String?, confirmTitle: String, confirmHandler: @escaping (_ text: String?) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = initialText
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default, handler: { action in
            
            guard alert.textFields != nil, let textField = alert.textFields?[0] else { return }
            
            confirmHandler(textField.text)
        }))
        
        viewControllerToPresentFrom?.present(alert, animated: true, completion: nil)
    }
    
    static func showActionSheet(withTitle title: String? = nil, message: String? = nil, actions: [UIAlertAction]? = nil, popoverConfig: (sourceView: UIView?, sourceRect: CGRect?, barButtonItem: UIBarButtonItem?)? = nil ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        if actions != nil {
            for action in actions! {
                alert.addAction(action)
            }
        }
        
        if alert.actions.filter({ $0.style == .cancel }).count == 0 {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = popoverConfig?.sourceView
            if let rect = popoverConfig?.sourceRect {
                alert.popoverPresentationController?.sourceRect = rect
            }
            alert.popoverPresentationController?.barButtonItem = popoverConfig?.barButtonItem
        }
        
        viewControllerToPresentFrom?.present(alert, animated: true, completion: nil)
    }
}
