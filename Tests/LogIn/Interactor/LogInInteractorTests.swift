//
//  LogInInteractorTests.swift
//

import XCTest
@testable import

class LogInInteractorTests: XCTestCase {

    private var interactor: LogInInteractor!

    // MARK: - Mocks

    private var presenter: LogInPresenterMock!
    private var api: EmailLoginAPIMock!
    private var userSession: ClientUserSessionMock!

    override func setUp() {
        super.setUp()

        presenter = LogInPresenterMock()

        api = EmailLoginAPIMock()
        userSession = ClientUserSessionMock()

        interactor = LogInInteractor(api: api, userSession: userSession)
        interactor.output = presenter
    }
    
    override func tearDown() {

        presenter = nil
        interactor = nil
        api = nil
        userSession = nil

        super.tearDown()
    }
    
    func testApiCallsWhenLoginDataIsValid() {

        api.shouldFail = false

        let data = ValidEmailLoginDataMock

        interactor.logIn(withEmail: data.email, password: data.password)

        XCTAssertTrue(api.logInCalled)
    }

    func testApiCallsWhenLoginDataIsInvalid() {

        api.shouldFail = false

        let data = InvalidEmailLoginDataMock

        interactor.logIn(withEmail: data.email, password: data.password)

        XCTAssertFalse(api.logInCalled)
    }

    func testOutputCallsWhenLoginDataIsValid() {

        api.shouldFail = false

        let data = ValidEmailLoginDataMock

        interactor.logIn(withEmail: data.email, password: data.password)

        XCTAssertTrue(presenter.didStartLoggingInCalled)
        XCTAssertTrue(presenter.didLogInCalled)
        XCTAssertFalse(presenter.didFailToLogInCalled)
        XCTAssertFalse(presenter.didFailToValidateLoginDataCalled)
        XCTAssertNil(presenter.error)
        XCTAssertNil(presenter.validationError)
    }

    func testOutputCallsWhenLoginDataIsInvalid() {

        api.shouldFail = false

        let data = InvalidEmailLoginDataMock

        interactor.logIn(withEmail: data.email, password: data.password)

        XCTAssertFalse(presenter.didStartLoggingInCalled)
        XCTAssertFalse(presenter.didLogInCalled)
        XCTAssertFalse(presenter.didFailToLogInCalled)
        XCTAssertTrue(presenter.didFailToValidateLoginDataCalled)
        XCTAssertNil(presenter.error)
        XCTAssertNotNil(presenter.validationError)
    }

    func testOutputCallsWhenApiFails() {

        api.shouldFail = true

        let data = ValidEmailLoginDataMock

        interactor.logIn(withEmail: data.email, password: data.password)

        XCTAssertTrue(presenter.didStartLoggingInCalled)
        XCTAssertFalse(presenter.didLogInCalled)
        XCTAssertTrue(presenter.didFailToLogInCalled)
        XCTAssertFalse(presenter.didFailToValidateLoginDataCalled)
        XCTAssertNotNil(presenter.error)
        XCTAssertNil(presenter.validationError)
    }

    func testUserSessionIsActiveAfterSuccessfulLogIn() {

        XCTAssertFalse(userSession.isActive)

        api.shouldFail = false

        let data = ValidEmailLoginDataMock

        interactor.logIn(withEmail: data.email, password: data.password)

        XCTAssertTrue(userSession.isActive)
    }
}
