//
//  UITableView+Ext.swift
//  Requestum
//
//  Created by Alex Kovalov on 5/1/18.
//  Copyright © 2018 Requestum. All rights reserved.
//

import UIKit

extension UITableView {
    
    func cell<T>() -> T {
        
        return dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
    }
}
