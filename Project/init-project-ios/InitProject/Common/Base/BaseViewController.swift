//
//  BaseViewController.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // use if needed
    }
}

// MARK: - SeguePerformer

extension BaseViewController: SeguePerformer {
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueInfo = sender as? SegueInfo else {
            return
        }
        
        segueInfo.configurationBlock?(segue.source, segue.destination)
    }
}

extension BaseViewController {
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if App.api != .production {
            
            var message = "Environment: \(App.api.rawValue)"
            message += "\nVersion: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "")(\(Bundle.main.infoDictionary?["CFBundleVersion"] ?? ""))"
            
            let logAction = UIAlertAction(title: "Logs", style: .default) { _ in
                if let  controller = Wormholy.wormholyFlow {
                    UIApplication.topViewController()?.present(controller, animated: true, completion: nil)
                }
            }
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in }
            AlertManager.showAlert(withTitle: "Info", message: message, actions: [logAction, okAction], style: .alert)
        }
    }
}
