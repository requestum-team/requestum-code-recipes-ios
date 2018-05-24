//
//  UserManager.swift
//  Requestum
//
//  Created by Alex Kovalov on 3/25/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import UIKit

import Alamofire


// MARK: - API

class UserManager: ObjectManager {
    
    static var shared = UserManager()
    
    func getGuestToken(_ completion: @escaping (_ error: NSError?) -> Void) {
        
        let params = [
            "grant_type": ServerAPI.SignUpAuth.grantType,
            "client_id": ServerAPI.SignUpAuth.clientId,
            "client_secret": ServerAPI.SignUpAuth.clientSecret
        ]
        
        request(.post, serverAPI: .authToken, parameters: params).responseJSON { response in
            
            if let token: Token = response.resultObject() {
                Token.guestToken = token
            }
            
            completion(response.resultError())
        }
    }
    
    func refreshToken(_ completion: @escaping (_ error: NSError?) -> Void) {
        
        guard let refreshToken = Token.currentToken?.refreshToken else {
            
            completion(NSError())
            return
        }
        
        let params = [
            "grant_type": "refresh_token",
            "client_id": ServerAPI.Auth.clientId,
            "client_secret": ServerAPI.Auth.clientSecret,
            "refresh_token": refreshToken
        ]
        
        request(.post, serverAPI: .authToken, parameters: params).responseJSON { response in
            
            if let token: Token = response.resultObject() {
                Token.currentToken = token
            }
            
            completion(response.resultError())
        }
    }
    
    func login(with email: String, password: String, _ completion: @escaping (_ error: NSError?) -> Void) {
        
        let params = [
            "grant_type": ServerAPI.Auth.grantType,
            "client_id": ServerAPI.Auth.clientId,
            "client_secret": ServerAPI.Auth.clientSecret,
            "username": email,
            "password": password
        ]
        
        request(.post, serverAPI: .authToken, parameters: params).responseJSON { response in
            
            if let token: Token = response.resultObject() {
                Token.currentToken = token
            }
            
            completion(response.resultError())
        }
    }
    
    func signUp(with email: String, password: String, username: String, _ completion: @escaping (_ error: NSError?, _ user: User?) -> Void) {
        
        let params: Parameters = [
            "username": username,
            "email": email,
            "password": password
        ]
        
        request(.post, serverAPI: .signUp, parameters: params).responseJSON { response in
            
            let user: User? = response.resultObject()
            
            completion(response.resultError(), user)
        }
    }
    
    func socialLogin(with token: String, backend: String, _ completion: @escaping (_ error: NSError?) -> Void) {
        
        let params = [
            "grant_type": "convert_token",
            "client_id": ServerAPI.Auth.clientId,
            "client_secret": ServerAPI.Auth.clientSecret,
            "token": token,
            "backend": backend
        ]
        
        request(.post, serverAPI: .convertToken, parameters: params).responseJSON { response in
            
            if let token: Token = response.resultObject() {
                Token.currentToken = token
            }
            
            completion(response.resultError())
        }
    }
    
    func getMe(completion: @escaping (_ error: NSError?, _ user: User?) -> Void) {
        
        request(.get, serverAPI: .user, parameters: nil).responseJSON { response in
            
            let user: User? = response.resultObject()
            
            completion(response.resultError(), user)
        }
    }
    
    func changePassword(_ password: String, newPassword: String, _ completion: @escaping (_ error: NSError?) -> Void) {
        
        let params = [
            "old_password": password,
            "new_password1": newPassword,
            "new_password2": newPassword
        ]
        
        request(.post, serverAPI: .changePassword, parameters: params).response { response in
            
            completion(response.error as NSError?)
        }
    }
    
    func forgotPassword(_ email: String? = nil, _ completion: @escaping (_ error: NSError?) -> Void) {
        
        var params: Parameters = [:]
        
        if let email = email {
            params["email"] = email
        }
        
        request(.post, serverAPI: .forgotPassword, parameters: params).response { response in
            
            completion(response.error as NSError?)
        }
    }
    
    func changeEmail(_ email: String, _ completion: @escaping (_ error: NSError?, _ user: User?) -> Void) {
        
        let params = [
            "email": email
        ]
        request(.patch, serverAPI: .user, parameters: params).responseJSON { response in
            
            let user: User? = response.resultObject()
            
            completion(response.resultError(), user)
        }
    }
    
    func updateUserPhoto(_ photo: UIImage?, _ completion: @escaping (_ error: NSError?, _ user: Profile?) -> Void) {
        
        var params: Parameters = [
            "avatar": NSNull()
        ]
        
        if let image = photo, let imageData = UIImagePNGRepresentation(image) {
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            params["avatar"] = strBase64
        }
        
        request(.patch, serverAPI: .profile, parameters: params).responseJSON { response in
            
            let profile: Profile? = response.resultObject()
            
            completion(response.resultError(), profile)
        }
    }
}
