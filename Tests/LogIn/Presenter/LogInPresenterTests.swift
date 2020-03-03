//
//  LogInPresenterTests.swift
//

import XCTest
@testable import

final class LogInPresenterTests: XCTestCase {
    
    private var presenter: LogInPresenter!

    // MARK: - Mocks

    private var view: LogInViewMock!
    private var router: LogInRouterMock!
    private var interactor: LogInInteractorMock!

    override func setUp() {
        super.setUp()

        view = LogInViewMock()
        router = LogInRouterMock()
        interactor = LogInInteractorMock()

        presenter = LogInPresenter()
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter
    }
    
    override func tearDown() {
        
        presenter = nil
        view = nil
        router = nil
        interactor = nil
        
        super.tearDown()
    }
    
    func testViewShowLoaderCalledWhenLogInStarts() {

        interactor.shouldFailToLogIn = false

        let data = ValidEmailLoginDataMock

        presenter.didEnterEmail(data.email, password: data.password)

        XCTAssertTrue(view.showLoaderCalled)
    }
    
    func testViewHidesLoaderWhenLogInFinishes() {

        interactor.shouldFailToLogIn = false

        let expecation = self.expectation(description: "View hides loader")

        let data = ValidEmailLoginDataMock
        
        presenter.didEnterEmail(data.email, password: data.password)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(2)) {
            expecation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { [weak self] error in
            
            XCTAssertNil(error, "Error: \(String(describing: error?.localizedDescription))")

            XCTAssertTrue(self?.view.hideLoaderCalled == true)
        }
    }

    func testViewHidesLoaderWhenLogInFails() {

        interactor.shouldFailToLogIn = true

        let data = ValidEmailLoginDataMock

        let expecation = self.expectation(description: "View hides loader")

        presenter.didEnterEmail(data.email, password: data.password)

        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(2)) {
            expecation.fulfill()
        }

        waitForExpectations(timeout: 1) { [weak self] error in

            XCTAssertNil(error, "Error: \(String(describing: error?.localizedDescription))")

            XCTAssertTrue(self?.view.hideLoaderCalled == true)
        }
    }
    
    func testThatViewShowsValidationErrorWhenInvalidDataPassed() {

        interactor.shouldFailToLogIn = false

        let data = InvalidEmailLoginDataMock

        presenter.didEnterEmail(data.email, password: data.password)

        XCTAssertTrue(view.showValidationErrorCalled)
    }

    func testThatViewShowsCorrectValidationError() {

        interactor.shouldFailToLogIn = false

        let data = InvalidEmailLoginDataMock

        presenter.didEnterEmail(data.email, password: data.password)

        XCTAssertTrue(view.validationError?.localizedDescription == interactor.validationError?.localizedDescription)
    }
    
    func testViewShowsErrorWhenLogInFails() {

        interactor.shouldFailToLogIn = true

        let data = ValidEmailLoginDataMock
        
        let expecation = self.expectation(description: "View shows error")

        presenter.didEnterEmail(data.email, password: data.password)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(2)) {
            expecation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { [weak self] error in
            
            XCTAssertNil(error, "Error: \(String(describing: error?.localizedDescription))")

            XCTAssertTrue(self?.view.showErrorCalled == true)
        }
    }

    func testViewShowsCorrectErrorWhenLogInFails() {

        interactor.shouldFailToLogIn = true

        let data = ValidEmailLoginDataMock

        let expecation = self.expectation(description: "View shows correct error")

        presenter.didEnterEmail(data.email, password: data.password)

        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(2)) {
            expecation.fulfill()
        }

        waitForExpectations(timeout: 1) { [weak self] error in

            XCTAssertNil(error, "Error: \(String(describing: error?.localizedDescription))")

            XCTAssertTrue(self?.view.errorMessage == self?.interactor.logInError?.localizedDescription)
        }
    }
    
    func testInteractorLogInCalled() {

        interactor.shouldFailToLogIn = false

        let data = ValidEmailLoginDataMock
        
        presenter.didEnterEmail(data.email, password: data.password)
        
        XCTAssertTrue(interactor.logInCalled)
    }

    func testRouterShowsMainWhenAuthorizationResultIsPersonalized() {

        interactor.shouldFailToLogIn = false
        interactor.resultShouldBePersonalized = true

        let expecation = self.expectation(description: "Router shows main")

        let data = ValidEmailLoginDataMock

        presenter.didEnterEmail(data.email, password: data.password)

        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(2)) {
            expecation.fulfill()
        }

        waitForExpectations(timeout: 1) { [weak self] error in

            XCTAssertNil(error, "Error: \(String(describing: error?.localizedDescription))")

            XCTAssertTrue(self?.router.showMainCalled == true)
        }
    }

    func testRouterShowsPersonalizationWhenAuthorizationResultIsNotPersonalized() {

        interactor.shouldFailToLogIn = false
        interactor.resultShouldBePersonalized = false

        let expecation = self.expectation(description: "Router shows personalization")

        let data = ValidEmailLoginDataMock

        presenter.didEnterEmail(data.email, password: data.password)

        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(2)) {
            expecation.fulfill()
        }

        waitForExpectations(timeout: 1) { [weak self] error in

            XCTAssertNil(error, "Error: \(String(describing: error?.localizedDescription))")

            XCTAssertTrue(self?.router.showPersonalizationCalled == true)
        }
    }

    func testRouterShowsResetPasswordWhenResetPasswordButtonTapped() {

        presenter.didTapResetPassword()

        XCTAssertTrue(router.showResetPasswordCalled)
    }
}
