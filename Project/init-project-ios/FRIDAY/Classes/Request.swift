//
//  Request.swift
//  FRIDAY
//
//  Created by Dima Hapich on 6/10/19.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation

import Alamofire
import os.log

public typealias Parameters = [String: Any]

open class Request {
    
    public typealias ProgressHandler = (Progress) -> Void

    public let url: URLConvertible
    public let method: HTTP.Method
    public let parameters: Parameters?
    public let multipartData: [MultipartData]?
    public let data: Data?
    public let headers: HTTP.Headers?
    public let formDataBuilder: FormDataBuilder
    public let encoding: ParameterEncoding
    
    let requestQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.isSuspended = true
        operationQueue.qualityOfService = .utility
        
        return operationQueue
    }()
    
    let parsingQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.isSuspended = true
        operationQueue.qualityOfService = .utility
        
        return operationQueue
    }()
    
    var internalRequest: Alamofire.DataRequest? {
        didSet {
            internalRequest?.validate(statusCode: 200..<400)
            requestQueue.isSuspended = false
        }
    }
    
    var internalResponse: Alamofire.DataResponse<Data>? {
        didSet {
            parsingQueue.isSuspended = false
        }
    }
    
    var internalError: Error? {
        didSet {
            parsingQueue.isSuspended = false
        }
    }
    
    init(
        url: URLConvertible,
        method: HTTP.Method,
        parameters: Parameters? = nil,
        multipartData: [MultipartData]? = nil,
        data: Data? = nil,
        formDataBuilder: FormDataBuilder = DefaultFormDataBuilder(),
        headers: HTTP.Headers? = nil,
        encoding: ParameterEncoding = JSONEncoding.default) {
        
        self.url = url
        self.method = method
        self.parameters = parameters
        self.multipartData = multipartData
        self.data = data
        self.formDataBuilder = formDataBuilder
        self.headers = headers
        self.encoding = encoding
    }
    
    @discardableResult
    public func uploadProgress(queue: DispatchQueue = .main, completion: @escaping ProgressHandler) -> Self {
        
        requestQueue.addOperation { [weak self] in
            if let uploadRequest = self?.internalRequest as? Alamofire.UploadRequest {
                uploadRequest.uploadProgress(queue: queue, closure: completion)
            }
        }
        
        return self
    }
    
    @discardableResult
    public func downloadProgress(queue: DispatchQueue = .main, completion: @escaping ProgressHandler) -> Self {
        
        requestQueue.addOperation { [weak self] in
            self?.internalRequest?.downloadProgress(queue: queue, closure: completion)
        }
        
        return self
    }
    
    open func resume() {
        
        requestQueue.addOperation { [weak self] in
            self?.internalRequest?.resume()
        }
    }
    
    open func suspend() {
        
        requestQueue.addOperation { [weak self] in
            self?.internalRequest?.suspend()
        }
    }
    
    open func cancel() {
        
        requestQueue.addOperation { [weak self] in
            self?.internalRequest?.cancel()
        }
    }
}

extension Request {
    
    @discardableResult
    public func response<Parser: ResponseParsing>(
        completeOn queue: DispatchQueue = .main,
        using parser: Parser,
        completion: @escaping (Response<Parser.Parsable, Parser.ParsingError>) -> Void) -> Self {
        
        parsingQueue.addOperation {
            
            let internalResponse = self.internalResponse
            
            let result = parser.parse(
                request: internalResponse?.request,
                response: internalResponse?.response,
                data: internalResponse?.data,
                error: internalResponse?.result.error ?? self.internalError
            )
            
            let response = Response(
                request: internalResponse?.request,
                response: internalResponse?.response,
                data: internalResponse?.data,
                result: result
            )
            
            queue.async {
                completion(response)
            }
        }
        
        return self
    }
    
    @discardableResult
    public func response<Error: ResponseError>(
        completeOn queue: DispatchQueue = .main,
        completion: @escaping (Response<Data?, Error>) -> Void) -> Self {
        
        let parser = ResponseParser<Data?, Error> { _, response, data, error in
            
            guard error == nil else {
                return .failure(Error(response: response, data: data, error: error))
            }
            
            return .success(data)
        }
        
        return response(completeOn: queue, using: parser, completion: completion)
    }
}

extension Request {
    
    @discardableResult
    public func log() -> Self {
        
        print("\nFRIDAY:\nRequest")
        print("\(method.rawValue) \(url.asURL().absoluteString)")
        
        if let headers = headers {
            print("Headers: \(headers)")
        }
        
        if let parameters = parameters {
            print("Parameters: \(parameters)")
        }
        
        if let multipartData = multipartData {
            print("Multipart Data: \(multipartData)")
        }
        
        print("\n")
        
        return self
    }
    
    @discardableResult
    public func logResponse() -> Self {
        
        parsingQueue.addOperation {
            
            if let response = self.internalResponse?.response, let url = response.url {
                
//                NSLog("\nFRIDAY: \(response.statusCode) \(self.method) \(url.absoluteString)\n\(response)")
                print("\nFRIDAY:\nResponse")
                print("\(response.statusCode) \(self.method) \(url.absoluteString)")
//                print("\(response)")
                
            } else if let internalError = self.internalError {
                
//                NSLog("\nFRIDAY: \(self.method) \(self.url.asURL().absoluteString)\nError: \(internalError.localizedDescription)")
                print("\nFRIDAY:")
                print("\(self.method) \(self.url.asURL().absoluteString)")
                print("Error: \(internalError.localizedDescription)")
                print("\n")
            }
        }
        
        return self
    }
}
