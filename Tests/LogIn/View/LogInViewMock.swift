//
//  LogInViewMock.swift
//

import Foundation
@testable import 

final class LogInViewMock: LogInView {

    var showLoaderCalled = false
    var hideLoaderCalled = false
    var showValidationErrorCalled = false
    var showErrorCalled = false
    var errorMessage: String?
    var validationError: ValidationError<EmailLoginData.Input>?

    func showLoader() {
        showLoaderCalled = true
    }

    func hideLoader() {
        hideLoaderCalled = true
    }

    func showValidationError(_ error: ValidationError<EmailLoginData.Input>) {
        showValidationErrorCalled = true
        validationError = error
    }

    func showError(with message: String) {
        errorMessage = message
        showErrorCalled = true
    }
}
