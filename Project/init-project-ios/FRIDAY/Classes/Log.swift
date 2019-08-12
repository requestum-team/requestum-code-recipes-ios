//
//  Log.swift
//  FRIDAY
//
//  Created by Dima Hapich on 6/10/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation

public struct Log {
    
   public static var logPath: URL?
    
    static func setup(with name: String = "Logger") {
        
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let logPath = docDirectory.appendingPathComponent("\(name).txt")
        Log.logPath = logPath
        freopen(logPath.path.cString(using: .ascii)!, "a+", stderr)
        let logpatho = docDirectory.appendingPathComponent("\(name).txt")
        freopen(logpatho.path.cString(using: .ascii)!, "a+", stdout)
    }
}
