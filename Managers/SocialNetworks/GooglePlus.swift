//
//  GooglePlus.swift
//
//
//  Created by Dima Hapich on 3/21/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

import GoogleSignIn

class GooglePlus: NSObject {
    
    static let shared = GooglePlus()
    
    var completionHandler: ((LoginResult) -> Void)?
    var viewController: UIViewController?
    
    public enum LoginResult {
        case loggedIn(token: String)
        case error(errorMessage: String?)
    }
    
    private static var clientId: String {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
            let clientId = dict["GoogleClientID"] as? String {
            
            return clientId
        }
        return ""
    }
    
    static func setup() {
        
        GIDSignIn.sharedInstance().clientID = clientId
        GIDSignIn.sharedInstance().delegate = shared
        GIDSignIn.sharedInstance().uiDelegate = shared
    }
    
    static func application(_ application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    static func login(from viewController: UIViewController, handler: @escaping (_ result: LoginResult) -> Void) {
        
        shared.completionHandler = handler
        shared.viewController = viewController
        GIDSignIn.sharedInstance().signIn()
    }
    
    static func authorized() -> Bool {
        
        return GIDSignIn.sharedInstance().hasAuthInKeychain()
    }
    
    static func logout() {
        
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().disconnect()
    }
    
    static func profile() -> GIDGoogleUser? {
        
        return GIDSignIn.sharedInstance().currentUser
    }
}


// MARK: - GIDSignInDelegate

extension GooglePlus: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            completionHandler?(.error(errorMessage: error.localizedDescription))
            return
        }
        
        // TODO depende of server side implementation use user.authentication.idToken or user.authentication.accessToken
        guard let token = user.authentication.idToken else {
            completionHandler?(.error(errorMessage: "Error Login GooglePlus"))
            return
        }
        completionHandler?(.loggedIn(token: token))
    }
}


// MARK: - GIDSignInUIDelegate

extension GooglePlus: GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
        self.viewController?.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
        viewController.dismiss(animated: true, completion: nil)
    }
}
