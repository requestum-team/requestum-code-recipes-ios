//
//  LogInPresenterMock.swift
//

import Foundation
@testable import 

final class LogInPresenterMock: LogInPresenting {

    var didEnterEmailCalled: Bool = false
    var didTapResetPasswordCalled: Bool = false

    var isPersonalized: Bool?
    var error: Error?
    var validationError: ValidationError<EmailLoginData.Input>?

    var didStartLoggingInCalled: Bool = false
    var didLogInCalled: Bool = false
    var didFailToLogInCalled: Bool = false
    var didFailToValidateLoginDataCalled: Bool = false

    func didEnterEmail(_ email: String, password: String) {
        didEnterEmailCalled = true
    }

    func didTapResetPassword() {
        didTapResetPasswordCalled = true
    }
}

extension LogInPresenterMock: LogInInteractorOutput {

    func didStartLoggingIn() {
        didStartLoggingInCalled = true
    }

    func didLogIn(isPersonalized: Bool) {
        didLogInCalled = true
        self.isPersonalized = isPersonalized
    }

    func didFailToLogIn(withError error: Error) {
        didFailToLogInCalled = true
        self.error = error
    }

    func didFailToValidateLoginData(withError error: ValidationError<EmailLoginData.Input>) {
        didFailToValidateLoginDataCalled = true
        validationError = error
    }
}
