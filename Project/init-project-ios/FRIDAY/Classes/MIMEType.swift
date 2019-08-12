//
//  MIMEType.swift
//  FRIDAY
//
//  Created by Dima Hapich on 6/10/19.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation

extension HTTP {
    
    public enum MIMEType: String {
        
        case applicationJavascript = "application/javascript"
        case applicationJSON = "application/json"
        case applicationXwwwFormUrlencoded = "application/x-www-form-urlencoded"
        case applicationXML = "application/xml"
        case applicationZIP = "application/zip"
        case applicationPDF = "application/pdf"
        
        case audioMPEG = "audio/mpeg"
        case audioVorbis = "audio/vorbis"
        
        case multipartFormData = "multipart/form-data"
        
        case textCSS = "text/css"
        case textHTML = "text/html"
        case textPlain = "text/plain"
        
        case imagePNG = "image/png"
        case imageJPEG = "image/jpeg"
        case imageGIF = "image/gif"
    }
}
