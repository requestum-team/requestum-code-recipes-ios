//
//  Client.swift
//  FRIDAY
//
//  Created by Dima Hapich on 6/10/19.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireNetworkActivityIndicator

open class Client {
    
    public static var shared = Client()
    
    fileprivate let responseQueue = DispatchQueue(label: "client.response", attributes: [])
    
    public let manager: Alamofire.SessionManager
    public static var adapter: ((URLRequest) -> URLRequest)?
    public static var responseHandler: ((HTTPURLResponse?) -> Void)?
    public var retrier: RequestRetrier? {
        didSet {
            manager.retrier = retrier
        }
    }
    
    public var startRequestsImmediately: Bool = true {
        didSet {
            manager.startRequestsImmediately = startRequestsImmediately
        }
    }
    
    public var networkActivityIndicatorIsEnabled = false {
        didSet {
            NetworkActivityIndicatorManager.shared.isEnabled = networkActivityIndicatorIsEnabled
        }
    }

    
    public init(manager: Alamofire.SessionManager = Alamofire.SessionManager.default) {
        
        if FRIDAY.isLoggingEnabled {
//            Log.setup(with: "Name \(Date().timeIntervalSince1970)")
        }
        self.manager = manager
        self.manager.startRequestsImmediately = startRequestsImmediately
        self.manager.adapter = self
        
        NetworkActivityIndicatorManager.shared.startDelay = 0.0
    }
    
    @discardableResult
    public func request(
        _ url: URLConvertible,
        method: HTTP.Method,
        parameters: Parameters? = nil,
        multipartData: [MultipartData]? = nil,
        data: Data? = nil,
        formDataBuilder: FormDataBuilder = DefaultFormDataBuilder(),
        headers: HTTP.Headers? = nil, encoding: ParameterEncoding) -> Request {
        
        let request = Request(
            url: url,
            method: method,
            parameters: parameters,
            multipartData: multipartData,
            data: data,
            formDataBuilder: formDataBuilder,
            headers: headers,
            encoding: encoding
        )
        
        if FRIDAY.isLoggingEnabled {
            request.log()
        }
        
        alamofireRequest(for: request) { alamofireRequest, error in
            
            if let alamofireRequest = alamofireRequest {
                request.internalRequest = alamofireRequest
                
                alamofireRequest.responseData { response in
                    request.internalResponse = response
                    Client.responseHandler?(response.response)
                }
            } else {
                request.internalError = error
            }
            
            if FRIDAY.isLoggingEnabled {
                request.logResponse()
            }
        }
        
        return request
    }
    
    @discardableResult
    public func request(_ requestDataProvider: RequestDataProvider) -> Request {
        
        let url = requestDataProvider.baseUrl.asURL().appendingPathComponent(requestDataProvider.path)
        
        return self.request(
            url,
            method: requestDataProvider.method,
            parameters: requestDataProvider.parameters,
            multipartData: requestDataProvider.multipartData,
            data: requestDataProvider.data,
            formDataBuilder: requestDataProvider.formDataBuilder,
            headers: requestDataProvider.headers,
            encoding: requestDataProvider.encoding
        )
    }
}


extension Client {
    
    func alamofireRequest(for request: Request, completion: @escaping (Alamofire.DataRequest?, Error?) -> Void) {
        
        let method = request.method.asAlamofireHTTPMethod()
        
        if let data = request.data {
            
            let alamofireRequest = manager.upload(data, to: request.url.asURL(), method: method, headers: request.headers)
            completion(alamofireRequest, nil)
            
        } else if request.multipartData != nil {
            
            manager.upload(multipartFormData: { formData in
                
                request.formDataBuilder.fillFormData(formData, for: request)
                
            }, to: request.url.asURL(), method: method, headers: request.headers, encodingCompletion: { result in
                
                switch result {
                case .success(let upload, _, _):
                    
                    completion(upload, nil)
                    
                case .failure(let encodingError):
                    completion(nil, encodingError)
                }
            })
            
        } else {
            let alamofireRequest = manager.request(request.url.asURL(), method: method, parameters: request.parameters, encoding: request.encoding, headers: request.headers)
            
            completion(alamofireRequest, nil)
        }
    }
    
    public func cancelAllRequests() {
        
        manager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
}

extension Client: RequestAdapter {
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        return Client.adapter?(urlRequest) ?? urlRequest
    }

}
