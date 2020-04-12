//
//  DataResponse+Result.swift
//  Requestum
//
//  Created by Alex Kovalov on 5/1/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

import Alamofire

extension DataResponse {
    
    // MARK: - Error
    
    func resultError() -> NSError? {
        
        if result.error != nil {
            return (result.error! as NSError).with(dataResponse: self)
        }
        
        return nil
    }
    
    
    // MARK: - Result decode
    
    func resultObject<T: Decodable>() -> T? {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        if let data = data {
            if let obj = try? decoder.decode(T.self, from: data) {
                return obj
            }
        }
        return nil
    }
    
    func resultArray<T: Decodable>(by key: String? = nil) -> [T]? {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        if let strongKey = key {
            if let data = data {
                if let obj = try? decoder.decode([String: [T]].self, from: data) {
                    return obj[strongKey]
                }
            }
        } else if let data = data {
            if let array = try? decoder.decode([T].self, from: data) {
                return array
            }
        }
        return nil
    }
    
    
    // MARK: - JSON
    
    func JSON() -> [String: Any]? {
        
        var JSON: [String: Any]?
        
        if let json = result.value as? [String: Any] {
            JSON = json
        } else if let data = data, let json = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) as [String: Any]??) {
            JSON = json
        }
        
        return JSON
    }
    
    func JSONArray() -> [[String: AnyObject]]? {
        
        return result.value as? [[String: AnyObject]]
    }
}
