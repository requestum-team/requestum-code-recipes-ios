//
//  DatabaseManager.swift
//  Requestum
//
//  Created by Alex Kovalov on 5/1/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

import RealmSwift

fileprivate let StoreFileNameDefault = "default"
fileprivate let StoreFileExtension = "realm"
fileprivate let StoreFileDirectory = ""

class DatabaseManager: NSObject {
    
    static let shared = DatabaseManager()
    
    // MARK: Properties
    
    
    // MARK: Lifecycle
    
    init(storeName: String = StoreFileNameDefault) {
        super.init()
        
        var config = Realm.Configuration()
        config.fileURL = DatabaseManager.storeFileURL()
        config.schemaVersion = currentSchemaVersion()
        config.migrationBlock = { [weak self] migration, oldSchemaVersion in
            self?.migrate(with: migration, oldSchemaMigration: oldSchemaVersion)
        }
        Realm.Configuration.defaultConfiguration = config
    }
    
    static func deleteStoreFile(_ storeName: String = StoreFileNameDefault) {
        
        let fileURL = storeFileURL()
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try! FileManager.default.removeItem(at: fileURL)
        }
    }
    
    static func storeFileURL(_ storeName: String = StoreFileNameDefault) -> URL {
        
        let relativeFp = StoreFileDirectory + "/" + storeName + "." + StoreFileExtension
        let fileURL = FileManager.default.applicationDocumentsDirectory.appendingPathComponent(relativeFp)
        
        FileManager.default.ensureDirectoryExists(forFileURL: fileURL)
        
        return fileURL
    }
    
    
    // MARK: Actions
    
    // MARK: Write
    
    func addObject(_ object: Object) {
        
        write { (realm) in
            realm.add(object, update: true)
        }
    }
    
    func addArray(_ array: [Object]) {
        
        write { (realm) in
            realm.add(array, update: true)
        }
    }
    
    func change(_ changesBlock: () -> Void) {
        
        write { (realm) in
            changesBlock()
        }
    }
    
    func deleteObject(_ object: Object) {
        
        write { (realm) in
            realm.delete(object)
        }
    }
    
    func deleteArray(_ array: [Object]) {
        
        write { (realm) in
            realm.delete(array)
        }
    }
    
    fileprivate func write(_ changes: (Realm) -> Void) {
        
        let realm = try! Realm()
        do {
            try realm.safeWrite {
                changes(realm)
            }
        }
        catch (let error as NSError) {
            
            print(error.description)
        }
    }
    
    func deleteAll() {
        
        write { realm in
            realm.deleteAll()
        }
    }
    
    
    // MARK: Read
    
    func objects<T: Object>(_ type: T.Type) -> Results<T> {
        
        let realm = try! Realm()
        let results = realm.objects(type)
        return results
    }
}


// MARK: Safe write

extension Realm {
    
    public func safeWrite(_ block: (() throws -> Void)) throws {
        
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}


// MARK: Objects for Key

extension DatabaseManager {
    
    func objectsForKey<T: Object, V>(_ type: T.Type, key: String, value: V) -> Results<T> {
        
        return objects(type).filter("\(key) == %@", (value as AnyObject))
    }
    
    func objectsForKeys<T: Object, V>(_ type: T.Type, key: String, value: V) -> Results<T> {
        
        return objects(type).filter("\(key) IN %@", (value as AnyObject))
    }
    
    func objectForPrimaryKey<T: Object, V>(key: String, value: V) -> T? {
        
        return objects(T.self).filter("\(key) == %@", (value as AnyObject)).first
    }
}
