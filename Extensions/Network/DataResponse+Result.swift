//
//  DataResponse+Result.swift
//  Requestum
//
//  Created by Alex Kovalov on 5/1/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

import Alamofire
import ObjectMapper

extension DataResponse {
    
    // MARK: - Error
    
    func resultError() -> NSError? {
        
        if result.error != nil {
            return (result.error! as NSError).with(dataResponse: self)
        }
        
        return nil
    }
    
    
    // MARK: - Result Mapping
    
    func resultObject<T: Mappable>() -> T? {
        
        if let JSON = JSON() {
            if let obj = Mapper<T>().map(JSON: JSON) {
                return obj
            }
        }
        return nil
    }
    
    func resultArray<T: Mappable>(by key: String? = nil) -> [T]? {
        
        if let strongKey = key {
            if let JSONArray = JSON()?[strongKey] as? [[String: Any]] {
                
                let objs = Mapper<T>().mapArray(JSONArray: JSONArray)
                return objs
            } else {
                return nil
            }
        }
            
        else if let JSONArray = JSONArray() {
            let objs = Mapper<T>().mapArray(JSONArray: JSONArray)
            return objs
        }
        return nil
    }
    
    
    // MARK: - JSON
    
    func JSON() -> [String: Any]? {
        
        var JSON: [String : Any]?
        
        if let json = result.value as? [String: Any] {
            JSON = json
        } else if (data != nil), let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any] {
            JSON = json
        }
        
        return JSON
    }
    
    func JSONArray() -> [[String: AnyObject]]? {
        
        return result.value as? [[String: AnyObject]]
    }
}
