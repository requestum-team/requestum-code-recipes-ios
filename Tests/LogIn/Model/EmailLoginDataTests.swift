//
//  EmailLoginDataTests.swift
//

import XCTest
@testable import

fileprivate struct EmailLoginDataSuccessMock {
    let email = "test@test.ts"
    let password = "password"
}

fileprivate struct NotValidEmailLoginDataMock {
    let email = "test"
    let password = "password"
}

fileprivate struct EmptyPasswordLoginDataMock {
    let email = "test@test.ts"
    let password = ""
}

final class EmailLoginDataTests: XCTestCase {

    func testNotValidEmailValidation() {
        
        let dataMock = NotValidEmailLoginDataMock()
        
        let data = EmailLoginData(email: dataMock.email, password: dataMock.password)
        
        var validationError: Error?
        
        do {
            try data.validate()
        } catch let error {
            
            validationError = error

        }
        
        XCTAssertNotNil(validationError, "Validation Error is nil")
        XCTAssertNotNil(validationError?.localizedDescription, "Validation Error message is nil")
    }
    
    
    func testEmptyPasswordValidation() {
        
        let dataMock = EmptyPasswordLoginDataMock()
        
        let data = EmailLoginData(email: dataMock.email, password: dataMock.password)
        
        var validationError: Error?
        
        do {
            try data.validate()
        } catch let error {
            
            validationError = error
            
        }
        
        XCTAssertNotNil(validationError, "Validation Error is nil")
        XCTAssertNotNil(validationError?.localizedDescription, "Validation Error message is nil")
    }
    
    func testSuccessValidation() {
        
        let dataMock = ValidEmailLoginDataMock
        
        let data = EmailLoginData(email: dataMock.email, password: dataMock.password)
        
        var validationError: Error?
        
        do {
            try data.validate()
        } catch let error {
            
            validationError = error

        }
        
        XCTAssertNil(validationError, "Validation Error is not nil")
        XCTAssertNil(validationError?.localizedDescription, "Validation Error message is not nil")
    }
}
