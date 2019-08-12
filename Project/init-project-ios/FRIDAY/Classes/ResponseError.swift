//
//  ResponseError.swift
//  FRIDAY
//
//  Created by Dima Hapich on 6/10/19.
//  Copyright © 2017 Requestum. All rights reserved.
//

import Foundation

public protocol ResponseError: Error {
    init(response: HTTPURLResponse?, data: Data?, error: Error?)
}
