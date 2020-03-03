//
//  LoginRouterTests.swift
//

import XCTest
@testable import

final class LoginRouterTests: XCTestCase {
    
    var router: LogInRouter!
    var controller: LogInViewController!

    override func setUp() {
        super.setUp()
        
        controller = LogInViewControllerFactory.controller()

        router = LogInRouter()
        router.viewController = controller
    }
    
    override func tearDown() {
        
        router = nil
        controller = nil

        super.tearDown()
    }
    
    func testShouldShowResetPassword() {

        XCTAssertTrue(router.viewController.shouldPerformSegue(
            withIdentifier: R.string.segue.loginViewControllerShowResetPassword(),
            sender: nil))
    }
    
    func testShouldShowPersonalization() {

        XCTAssertTrue(router.viewController.shouldPerformSegue(
            withIdentifier: R.string.segue.loginViewControllerShowPersonalization(),
            sender: nil))
    }
}
