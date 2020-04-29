//
//  ValidationError.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation

protocol ValidatableAttribute {
    var title: String { get }
}

enum ValidationError: Error {
    
    case empty(_: ValidatableAttribute)
    case invalid(_: ValidatableAttribute)
    case doNotMatch(_: ValidatableAttribute, ValidatableAttribute)
    case custom(_: ValidatableAttribute, text: String)
    case compound(_: [ValidationError])
    
    var message: String {
        
        switch self {
        case .empty(let attribute):
            return R.string.validation.attributeIsEmpty(attribute.title)
        case .invalid(let attribute):
            return R.string.validation.attributeIsInvalid(attribute.title)
        case .doNotMatch(let firstAttribute, let secondAttribute):
            return R.string.validation.attributesDoNotMatch(firstAttribute.title, secondAttribute.title)
        case .custom(_, let text):
            return text
        case .compound:
            return ""
        }
    }
    
    var attribute: ValidatableAttribute {
        
        switch self {
        case .empty(let attribute):
            return attribute
        case .invalid(let attribute):
            return attribute
        case .doNotMatch(_, let secondAttribute):
            return secondAttribute
        case .custom(let attribute, _):
            return attribute
        case .compound(let errors):
            return errors.first!.attribute // force unwrap is intentionally
        }
    }
}

extension ValidationError {
    
    var hasEmpty: Bool {
        
        switch self {
        case .compound(let errors):
            return errors.contains { (error) -> Bool in
                switch error {
                case .empty:
                    return true
                default:
                    return false
                }
            }
        case .empty:
            return true
        default:
            return false
        }
    }
}
