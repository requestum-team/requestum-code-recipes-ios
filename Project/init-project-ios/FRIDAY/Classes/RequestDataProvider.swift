//
//  RequestDataProvider.swift
//  FRIDAY
//
//  Created by Dima Hapich on 6/10/19.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation
import Alamofire

public protocol RequestDataProvider {
    
    var baseUrl: URLConvertible { get }
    var path: String { get }
    var method: HTTP.Method { get }
    var parameters: Parameters? { get }
    var multipartData: [MultipartData]? { get }
    var data: Data? { get }
    var headers: HTTP.Headers? { get }
    var formDataBuilder: FormDataBuilder { get }
    var encoding: ParameterEncoding { get }
}

public extension RequestDataProvider {
    
    var method: HTTP.Method {
        return .get
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var headers: HTTP.Headers? {
        return nil
    }
    
    var multipartData: [MultipartData]? {
        return nil
    }
    
    var data: Data? {
        return nil
    }
    
    var formDataBuilder: FormDataBuilder {
        return DefaultFormDataBuilder()
    }
    
    var encoding: ParameterEncoding {
    
        return JSONEncoding.default
    }
}
