//
//  Twitter.swift
//
//
//  Created by Dima Hapich on 7/23/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation
import TwitterKit

struct Twitter {
    
    private static var twitterConsumerKey: String {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
            let consumerKey = dict["TwitterConsumerKey"] as? String  {
            
            return consumerKey
        }
        return ""
    }
    
    private static var twitterConsumerSecret: String {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
            let consumerSecret = dict["TwitterConsumerSecret"] as? String  {
            
            return consumerSecret
        }
        return ""
    }
    
    private static let defaults = UserDefaults.standard
    
    static func setup() {
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        
    }
    
    static func login(from viewController: UIViewController, handler: @escaping (_ result: SocialManager.LoginResult) -> Void) {
        
        TWTRTwitter.sharedInstance().logIn(with: viewController, completion: { (session, error) in
            
            if let authToken = session?.authToken {
                handler(.loggedIn(token: authToken))
            } else {
                handler(.error(errorMessage: error?.localizedDescription))
            }
        })
    }
    
    static func logout() {
        
        let store = TWTRTwitter.sharedInstance().sessionStore
        
        if let userId = store.session()?.userID {
            store.logOutUserID(userId)
        }
    }
    
    static func authorized() -> Bool {
        
        let store = TWTRTwitter.sharedInstance().sessionStore
        return store.session()?.userID != nil
    }
    
    static func tokenString() -> String? {
        let store = TWTRTwitter.sharedInstance().sessionStore
        return store.session()?.authToken
    }
    
    static func twitterHeader() -> [String: String]? {
        
        if let session = TWTRTwitter.sharedInstance().sessionStore.session() as? TWTRSession {
            let headerSigner = TWTROAuthSigning(authConfig: TWTRTwitter.sharedInstance().authConfig, authSession: session)
            return headerSigner.oAuthEchoHeadersToVerifyCredentials() as? Dictionary<String,String>
        } else  {
            return nil
        }
    }
    
    static func twitterHeaderString() -> String? {
        
        guard let session = TWTRTwitter.sharedInstance().sessionStore.session() else {
            return nil
        }
        
        return "\(session.authToken)|\(session.authTokenSecret)"
    }
    
    static func loadMe(completion: ((_ profile: TWTRUser?) -> Void)? = nil ) {
        
        if let session = TWTRTwitter.sharedInstance().sessionStore.session() {
            let twitterClient = TWTRAPIClient(userID: session.userID)
            twitterClient.loadUser(withID: session.userID, completion: { (user, error) in
                guard error != nil else{
                    print("Error load twitter profile: \(error?.localizedDescription ?? "")")
                }
                completion?(user)
            })
        }
    }
}
