//
//  DataSource.swift
//  Requestum
//
//  Created by Alex Kovalov on 5/1/18.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation

import ObjectMapper

/**
 Save simple types to UserDefaults directly and by converting objects to JSON string with ObjectMapper.
 
 Example:
 ```
 static var currentUser: User? {
    get { return DataSource.mappable() }
    set { DataSource.setMappable(newValue) }
 }
 ```
*/
class DataSource<T: Mappable> {
    
    // MARK: - User Defaults
    
    class func value(forKey: String) -> Any? {
        
        return UserDefaults.standard.value(forKey: forKey)
    }
    
    class func set(_ value: Any?, forKey: String) {
        
        UserDefaults.standard.set(value, forKey: forKey)
    }
    
    
    // MARK: - Mappable single object
    
    class func setMappable(_ value: T?, forKey: String = String(describing: T.self)) {
        
        guard let v = value else {
            return set(value, forKey: forKey)
        }
        
        set(Mapper<T>().toJSONString(v), forKey: forKey)
    }
    
    class func mappable(forKey: String = String(describing: T.self), mapper: Mapper<T> = Mapper<T>()) -> T? {
        
        if let jsonString = value(forKey: forKey) as? String {
            return mapper.map(JSONString: jsonString)
        }
        return nil
    }
    
    
    // MARK: - Mappable objects array
    
    class func setMappableArray(_ value: [T]?, forKey: String = String(describing: T.self)) {
        
        guard let v = value else {
            return set(value, forKey: forKey)
        }
        set(Mapper().toJSONString(v), forKey: forKey)
    }
    
    class func mappableArray(forKey: String = String(describing: T.self), mapper: Mapper<T> = Mapper<T>()) -> [T]? {
        
        if let jsonString = value(forKey: forKey) as? String {
            return mapper.mapArray(JSONString: jsonString)
        }
        return nil
    }
}
