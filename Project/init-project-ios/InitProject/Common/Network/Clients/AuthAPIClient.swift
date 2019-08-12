//
//  AuthAPIClient.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation
import enum Swift.Result

import FRIDAY
import Alamofire

protocol AuthAPIClientProvider {
    
    func getGuestToken(_ completion: @escaping (_ response: Result<Credentials, APIError>) -> Void)
    func signIn(with data: SignInData, completion: @escaping (_ response: Result<Credentials, APIError>) -> Void)
    func signUp(with data: SignUpData, completion: @escaping (_ response: Result<User, APIError>) -> Void)
    func forgotPassword(with email: String, completion: @escaping (_ response: Result<Bool, APIError>) -> Void)
}

//struct MockAuthAPIClient: AuthAPIClientProvider {
//    
//    fileprivate func delay(seconds: Double, completion: @escaping () -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
//    }
//    
//    func signIn(with data: SignInData, completion: @escaping (_ response: Result<Credentials, APIError>) -> Void) {
//        
//        delay(seconds: 1.0) {
//            
//            completion(.success(Mock.credentials))
//        }
//    }
//    
//    func signUp(with data: SignUpData, completion: @escaping (_ response: Result<User, APIError>) -> Void) {
//        
//        Mock.userIncomplete.email = data.email
//        
//        delay(seconds: 1.0) {
//            
//            completion(.success(Mock.userClient))
//        }
//    }
//    
//    func forgotPassword(with email: String, completion: @escaping (_ response: Result<Bool, APIError>) -> Void) {
//        
//        delay(seconds: 1.0) {
//            
//            completion(.success(true))
//        }
//    }
//    
//    func getGuestToken(_ completion: @escaping (_ response: Result<Credentials, APIError>) -> Void) {
//        
//        delay(seconds: 1.0) {
//            
//            completion(.success(Mock.credentials))
//        }
//    }
//}

final class AuthAPIClient {
    
    static var shared: AuthAPIClient = AuthAPIClient()
    
    private let lock = NSLock()
    private var isUpdateToken: Bool = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    enum Route: APIRequestDataProvider {
        
        case guestToken
        case refreshToken
        case signIn(data: SignInData)
        case signUp(data: SignUpData)
        case forgotPassword(email: String)
        
        var method: HTTP.Method {
            
            switch self {
            case .signUp:
                return .post
            default:
                return .post
            }
        }
        
        var path: String {
            
            switch self {
            case .guestToken, .signIn, .refreshToken:
                return "/oauth/v2/token"
            case .signUp:
                return "api/users"
            default:
                return ""
            }
        }
        
        var parameters: Parameters? {
            
            switch self {
            case .guestToken:
                
                let parameters: [String: Any] = [
                    "client_id": App.api.clientID,
                    "client_secret": App.api.clientSecret,
                    "grant_type": "client_credentials"
                ]
                
                return parameters
                
            case .refreshToken:
                
                if let refreshToken = App.userSession.refreshToken {
                    
                    return ["grant_type": "refresh_token",
                            "client_id": App.api.clientID,
                            "client_secret": App.api.clientSecret,
                            "refresh_token": refreshToken
                    ]
                } else {
                    return nil
                }
                
            case .signIn(let data):
                
                let parameters: [String: Any] = [
                    "client_id": App.api.clientID,
                    "client_secret": App.api.clientSecret,
                    "username": data.email,
                    "password": data.password,
                    "grant_type": "password"
                ]
                
                return parameters
                
            case .signUp(let data):
                
                let parameters: [String: Any] = [
                    "email": data.email,
                    "plainPassword": data.password
                ]
                
                return parameters
                
            default:
                return nil
            }
        }
        
        var encoding: ParameterEncoding {
            
            switch self {
            case .guestToken:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }
    }
    
    func refreshToken(completion: @escaping (_ response: Response<Credentials, APIError>) -> Void) {
        
        FRIDAY.request(Route.refreshToken).responseJSON(completion: completion)
    }
}

// MARK: - AuthAPIClintable

extension AuthAPIClient: AuthAPIClientProvider {
    
    func getGuestToken(_ completion: @escaping (_ response: Result<Credentials, APIError>) -> Void) {
        
        FRIDAY.request(Route.guestToken).responseJSON { (response: Response<Credentials, APIError>) in
            completion(response.result)
        }
    }
    
    func signIn(with data: SignInData, completion: @escaping (_ response: Result<Credentials, APIError>) -> Void) {
        
        FRIDAY.request(Route.signIn(data: data)).responseJSON { (response: Response<Credentials, APIError>) in
            completion(response.result)
        }
    }
    
    func signUp(with data: SignUpData, completion: @escaping (_ response: Result<User, APIError>) -> Void) {
        
        FRIDAY.request(Route.signUp(data: data)).responseJSON { (response: Response<User, APIError>) in
            completion(response.result)
        }
    }
    
    func forgotPassword(with email: String, completion: @escaping (_ response: Result<Bool, APIError>) -> Void) {
        
        FRIDAY.request(Route.forgotPassword(email: email)).responseJSON { (response: Response<Bool, APIError>) in
            completion(response.result)
        }
    }
}

extension AuthAPIClient: RequestRetrier {
    
    public func should(_ manager: SessionManager, retry request: Alamofire.Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        lock.lock() ; defer { lock.unlock() }
        
        if let httpResponse = request.task?.response as? HTTPURLResponse,
            let statusCode = HTTP.StatusCode(rawValue: httpResponse.statusCode),
            statusCode == .unauthorized || statusCode == .forbidden {
            
            requestsToRetry.append(completion)
            
            guard !isUpdateToken else {
                return
            }
            
            isUpdateToken = true
            self.refreshToken { [weak self] resopnse in
                switch resopnse.result {
                case .failure(let error):
                    
                    self?.requestsToRetry.forEach { $0(false, 0.0) }
                    self?.requestsToRetry.removeAll()
                    App.logout()
                case .success(let credentials):
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    do {
                        try App.userSession.activate(with: credentials)
                    } catch {
                        
                    }
                    
                    strongSelf.lock.lock(); defer { strongSelf.lock.unlock() }
                    
                    strongSelf.requestsToRetry.forEach { $0(true, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
            
        } else {
            
            completion(false, 0.0)
        }
    }
}
