//
//  DatabaseManager+Schema.swift
//  Requestum
//
//  Created by Alex Kovalov on 5/1/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

import RealmSwift

extension DatabaseManager {
    
    func currentSchemaVersion() -> UInt64 {
        
        return 1
    }
    
    func migrate(with migration: Migration, oldSchemaMigration: UInt64) {
        
        if oldSchemaMigration < 1 { } // fields, entities that were added, removed or changed
    }
}
