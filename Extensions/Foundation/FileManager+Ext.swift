//
//  NSFileManager+Ext.swift
//  Requestum
//
//  Created by Alex Kovalov on 5/1/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import Foundation

extension FileManager {
    
    var applicationDocumentsDirectory: URL {
        
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func ensureDirectoryExists(forFileURL fileURL: URL) {
        
        var fp = fileURL.path
        
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: fp, isDirectory: &isDir) {
            return
        }
        
        if !isDir.boolValue {
            
            fp = fileURL.deletingLastPathComponent().path
            
            if FileManager.default.fileExists(atPath: fp) {
                return
            }
        }
        
        do {
            try FileManager.default.createDirectory(at: URL(fileURLWithPath: fp), withIntermediateDirectories: true, attributes: nil)
        }
        catch let error {
            print(error)
        }
    }
}
