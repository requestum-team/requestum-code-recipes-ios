//
//  Multipart.swift
//  FRIDAY
//
//  Created by Dima Hapich on 6/10/19.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation

public enum MultipartDataType: CustomStringConvertible {
    case data(Data)
    case url(URL)
    case stream(stream: InputStream, length: UInt64)
    
    public var description: String {
        
        switch self {
        case .data(let data):
            return "\(data.count) bytes"
        case .url(let url):
            return "url: \(url)"
        case .stream(_, let length):
            return "stream: \(length) bytes"
        }
    }
}

public struct MultipartData: CustomStringConvertible {
    public let data: MultipartDataType
    public let fileName: String
    public let parameterName: String
    public let mimeType: String
    
    public init(data: MultipartDataType, fileName: String, parameterName: String, mimeType: String) {
        
        self.data = data
        self.fileName = fileName
        self.parameterName = parameterName
        self.mimeType = mimeType
    }
    
    public var description: String {
        return "data: \(data)\nfileName: \(fileName)\nparameterName: \(parameterName)\nmimeType: \(mimeType)"
    }
}
