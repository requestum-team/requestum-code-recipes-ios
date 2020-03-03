//
//  EmailLoginDataMock.swift
//

import Foundation
@testable import 

var ValidEmailLoginDataMock: EmailLoginData {

    return EmailLoginData(
        email: "test@themindstudios.com",
        password: "password"
    )
}

var InvalidEmailLoginDataMock: EmailLoginData {

    return EmailLoginData(
        email: "test",
        password: "password"
    )
}
