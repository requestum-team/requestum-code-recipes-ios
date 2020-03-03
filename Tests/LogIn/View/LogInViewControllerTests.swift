//
//  LogInViewControllerTests.swift
//

import XCTest
import SVProgressHUD
@testable import 

final class LogInViewControllerTests: XCTestCase {

    private var controller: LogInViewController!

    // MARK: - Mocks

    private var presenter: LogInPresenterMock!
    
    override func setUp() {
        super.setUp()
        
        controller = LogInViewControllerFactory.controller()
        controller.loadViewIfNeeded()

        presenter = LogInPresenterMock()
        controller.presenter = presenter
    }
    
    override func tearDown() {
        
        controller = nil
        presenter = nil

        super.tearDown()
    }

    func testOutlets() {
        XCTAssertNotNil(controller.emailTextField)
        XCTAssertNotNil(controller.passwordTextField)
        XCTAssertNotNil(controller.loginButton)
        XCTAssertNotNil(controller.resetPasswordButton)
        XCTAssertNotNil(controller.scrollView)
        XCTAssertNotNil(controller.scrollViewBottomConstraint)
        XCTAssertNotNil(controller.titleLabel)
    }

    func testThereIsNoFirstResponderWhenViewWillAppear() {

        controller.viewWillAppear(true)

        XCTAssertFalse(controller.emailTextField.isFirstResponder)
        XCTAssertFalse(controller.passwordTextField.isFirstResponder)
    }

    func testTextFieldsShouldReturn() {
        XCTAssert(controller.textFieldShouldReturn(controller.emailTextField))
        XCTAssert(controller.textFieldShouldReturn(controller.passwordTextField))
    }

    func testResetPasswordAction() {
        
        controller.resetPassword()

        XCTAssertTrue(presenter.didTapResetPasswordCalled)
    }

    func testLogInAction() {

        controller.logIn()
        
        XCTAssertTrue(presenter.didEnterEmailCalled)
    }

    func testShowLoader() {

        controller.showLoader()
        
        XCTAssert(HUD.isVisible)
    }
    
    func testHideLoader() {

        controller.hideLoader()
        
        XCTAssertFalse(HUD.isVisible)
    }

    func testEmptyEmailValidationError() {

        let error: ValidationError<EmailLoginData.Input> = .empty(.email)

        controller.showValidationError(error)

        XCTAssertNotNil(controller.emailTextField.errorLabel.text)
        XCTAssertNil(controller.passwordTextField.errorLabel.text)
        XCTAssertEqual(controller.emailTextField.errorLabel.text, error.localizedDescription)
    }

    func testInvalidEmailValidationError() {

        let error: ValidationError<EmailLoginData.Input> = .invalid(.email)

        controller.showValidationError(error)

        XCTAssertNotNil(controller.emailTextField.errorLabel.text)
        XCTAssertNil(controller.passwordTextField.errorLabel.text)
        XCTAssertEqual(controller.emailTextField.errorLabel.text, error.localizedDescription)
    }

    func testEmptyPasswordValidationError() {

        let error: ValidationError<EmailLoginData.Input> = .empty(.password)

        controller.showValidationError(error)

        XCTAssertNil(controller.emailTextField.errorLabel.text)
        XCTAssertNotNil(controller.passwordTextField.errorLabel.text)
        XCTAssertEqual(controller.passwordTextField.errorLabel.text, error.localizedDescription)
    }
}


