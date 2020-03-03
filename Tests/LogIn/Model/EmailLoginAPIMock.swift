//
//  EmailLoginAPIMock.swift
//

import Foundation

@testable import

final class EmailLoginAPIMock: EmailLoginAPI {

    var shouldFail: Bool = false
    var logInCalled: Bool = false
    var resultShouldBePersonalized: Bool = false

    func logIn(withEmail email: String, password: String, completion: @escaping (Response<AuthorizationResult, APIError>) -> Void) {

        logInCalled = true

        if shouldFail {

            let error: APIError = .network(.internalServerError, message: nil)

            let response = Response<AuthorizationResult, APIError>(request: nil, response: nil, data: nil, result: .failure(error))

            completion(response)

        } else {

            let result = AuthorizationResultMockFactory.authorizationResult(isPersonalized: resultShouldBePersonalized)

            let response = Response<AuthorizationResult, APIError>(request: nil, response: nil, data: nil, result: .success(result))
            
            completion(response)
        }
    }
}
