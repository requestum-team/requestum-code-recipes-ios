//
//  LogInRouterMock.swift
//

import Foundation
@testable import 

final class LogInRouterMock: LogInRouting {

    var showMainCalled: Bool = false
    var showResetPasswordCalled: Bool = false
    var showPersonalizationCalled: Bool = false

    func showMain() {
        showMainCalled = true
    }

    func showResetPassword() {
        showResetPasswordCalled = true
    }

    func showPersonalization() {
        showPersonalizationCalled = true
    }
}

