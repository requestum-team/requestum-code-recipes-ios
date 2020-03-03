//
//  LogInInteractorMock.swift
//

import Foundation
@testable import

final class LogInInteractorMock: LogInInteracting {

    weak var output: LogInInteractorOutput!

    private let api = EmailLoginAPIMock()

    var logInCalled: Bool = false
    var shouldFailToLogIn: Bool = false
    var resultShouldBePersonalized: Bool = true
    var logInError: Error?
    var validationError: ValidationError<EmailLoginData.Input>?

    func logIn(withEmail email: String, password: String) {

        logInCalled = true

        do {
            let trimmedEmail = email.trimmed()

            let loginData = EmailLoginData(email: trimmedEmail, password: password)

            try loginData.validate()

            output.didStartLoggingIn()

            api.shouldFail = shouldFailToLogIn

            api.logIn(withEmail: loginData.email, password: loginData.password) { [weak self] response in

                guard let strongSelf = self else {
                    return
                }

                switch response.result {
                case .failure(let error):
                    strongSelf.logInError = error
                    strongSelf.output.didFailToLogIn(withError: error)
                case .success:
                    strongSelf.output.didLogIn(isPersonalized: strongSelf.resultShouldBePersonalized)
                }
            }

        } catch let error as ValidationError<EmailLoginData.Input> {
            validationError = error
            output.didFailToValidateLoginData(withError: error)
        } catch {}
    }
}
