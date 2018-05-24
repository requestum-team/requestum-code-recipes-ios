//
//  ObjectManager.swift
//  Requestum
//
//  Created by Alex Kovalov on 3/20/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireNetworkActivityIndicator
import ObjectMapper
import HTTPStatusCodes

typealias JSON = [String: Any]
typealias JSONArray = [[String: Any]]

class ObjectManager {
    
    var isUpdateToken: Bool = false
    
    public let manager: Alamofire.SessionManager
    public static var adapter: ((URLRequest) -> URLRequest)?
    
    private let lock = NSLock()
    
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    public init(manager: Alamofire.SessionManager = Alamofire.SessionManager.default) {
        
        self.manager = manager
        self.manager.adapter = self
        self.manager.retrier = self
    }
    
    func headers() -> HTTPHeaders {
        
        var headers: HTTPHeaders = [:]
        
        headers["Content-Type"] = "application/json"
        headers["Cookie"] = ""
        
        return headers
    }
    
    func request(_ method: HTTPMethod,
                 serverAPI: ServerAPI,
                 parameters: Parameters? = nil,
                 urlParameters: [String: String]? = nil,
                 encoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {
        
        let url = serverAPI.fullURL.replacingURLParameters(urlParameters: urlParameters)
        
        let dataRequest = manager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers())
        
        return dataRequest.validate { urlRequest, urlResponse, data -> Request.ValidationResult in
            
            return self.validate(urlRequest: urlRequest, httpUrlResponce: urlResponse, data: data)
        }
    }
}


// MARK: - RequestRetrier, RequestAdapter

extension ObjectManager: RequestRetrier, RequestAdapter {
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == HTTPStatusCode.unauthorized.rawValue || response.statusCode == HTTPStatusCode.forbidden.rawValue {
            
            requestsToRetry.append(completion)
            
            guard !isUpdateToken else {
                return
            }
            isUpdateToken = true
            
            UserManager.shared.refreshToken { [weak self]  error in
                
                self?.isUpdateToken = false
                guard error == nil else {
                    
                    self?.requestsToRetry.forEach { $0(false, 0.0) }
                    self?.requestsToRetry.removeAll()
                    App.logout()
                    return
                }
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.lock.lock(); defer { strongSelf.lock.unlock() }
                
                strongSelf.requestsToRetry.forEach { $0(true, 0.0) }
                strongSelf.requestsToRetry.removeAll()
            }
            
        } else {
            
            completion(false, 0.0)
        }
    }
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        if let token = Token.currentToken, let type = token.tokenType, let str = token.accessToken {
            var urlRequest = urlRequest
            urlRequest.setValue(type + " " + str, forHTTPHeaderField: "Authorization")
            return urlRequest
            
        } else if let token = Token.guestToken, let type = token.tokenType, let str = token.accessToken {
            var urlRequest = urlRequest
            urlRequest.setValue(type + " " + str, forHTTPHeaderField: "Authorization")
            return urlRequest
        }
        
        return urlRequest
    }
}


// MARK: - Validation

extension ObjectManager {
    
    func validate(urlRequest: URLRequest?, httpUrlResponce: HTTPURLResponse, data: Data?) -> Request.ValidationResult {
        
        if httpUrlResponce.statusCode == HTTPStatusCode.unauthorized.rawValue {
            
            return Request.ValidationResult.failure(NSError.refreshTokenError())
        } else if Array(200..<300).contains(httpUrlResponce.statusCode) {
            
            return Request.ValidationResult.success
        } else {
            let reason: AFError.ResponseValidationFailureReason = .unacceptableStatusCode(code: httpUrlResponce.statusCode)
            return .failure(AFError.responseValidationFailed(reason: reason))
        }
    }
}
