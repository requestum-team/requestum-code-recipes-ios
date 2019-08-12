//
//  FRIDAY.swift
//  FRIDAY
//
//  Created by Dima Hapich on 6/10/19.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireNetworkActivityLogger

@discardableResult
public func request(
    _ url: URLConvertible,
    method: HTTP.Method,
    parameters: Parameters? = nil,
    multipartData: [MultipartData]? = nil,
    formDataBuilder: FormDataBuilder = DefaultFormDataBuilder(),
    headers: HTTP.Headers? = nil,
    encoding: ParameterEncoding) -> Request {
    
    return Client.shared.request(
        url,
        method: method,
        parameters: parameters,
        multipartData: multipartData,
        formDataBuilder: formDataBuilder,
        headers: headers,
        encoding: encoding
    )
}

@discardableResult
public func request(_ requestDataProvider: RequestDataProvider) -> Request {
    
    return Client.shared.request(requestDataProvider)
}

public func setRetrier(_ retrier: RequestRetrier) {
    
     Client.shared.retrier = retrier
}

public var logger: NetworkActivityLogger = NetworkActivityLogger.shared
public var isLoggingEnabled: Bool = false
