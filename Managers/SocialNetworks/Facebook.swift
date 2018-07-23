//
//  Facebook.swift
//
//
//  Created by Dima Hapich on 11/22/17.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation

import FBSDKLoginKit
import FBSDKShareKit
import FBSDKCoreKit

struct Facebook {
    
    private static var appId: String {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
            let appId = dict["FacebookAppID"] as? String  {
            
            return appId
        }
        return ""
    }
    
    private static var appLink: URL {
        return  URL(string: "https://fb.me/\(appId)")!
    }
    
    fileprivate static let readPermissions = ["email", "public_profile"] // add necessary read permissions
    fileprivate static let publishPermissions = [ "manage_pages", "publish_pages"] // add necessary write permissions
    
    static func setup() {
        
        FBSDKSettings.setAppID(appId)
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
    }
    
    static func authorized() -> Bool {
        
        if FBSDKAccessToken.current()?.tokenString != nil {
            return true
        } else {
            return false
        }
    }
    
    static func profile() -> FBSDKProfile? {
        
       return FBSDKProfile.current()
    }
    
    static func loadMe(completion: ((_ profile: FBSDKProfile?) -> Void)? = nil ) {
        FBSDKProfile.loadCurrentProfile { (profile, error) in
            completion?(profile)
        }
    }
    
    static func tokenString() -> String? {
        return FBSDKAccessToken.current()?.tokenString
    }
    
    static func logout() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    static func login(from viewController: UIViewController, handler: @escaping (_ result: SocialManager.LoginResult) -> Void) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        loginManager.loginBehavior = .native
        
        loginManager.logIn(withPublishPermissions: Facebook.publishPermissions, from: viewController)  { result, error in
            
            if let error = error {
                handler(.error(errorMessage: error.localizedDescription))
                return
            }
            
            guard let result = result else {
                handler(.error(errorMessage: "Error Login Facebook"))
                return
            }
            
            if result.isCancelled {
                handler(.cancelled)
            } else {
                
                handler(.loggedIn(token: result.token.tokenString))
            }
        }
    }
    
    static func makePost(text: String) {
        
        var params: [String: Any] = [:]
        params["message"] = text
        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/feed", parameters: params, httpMethod: "POST")
        
        request.start { (connections, result, error) in
            App.log.info(connections)
            App.log.info(result)
            App.log.info(error)
        }
        
    }
    
    static func getFeed() {
    
        let params: [String: Any] = [:]
        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/feed", parameters: params, httpMethod: "GET")
        request.start { (connections, result, error) in
            App.log.info(connections)
            App.log.info(result)
            App.log.info(error)
        }
    }
    
    static func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    static func application(_ application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    static func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return  FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options)
    }
}
