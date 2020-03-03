//
//  LogInModuleTests.swift
//

import XCTest
@testable import

final class LogInModuleTests: XCTestCase {
    
    var module: LogInModule!
    var viewController: LogInViewController!
    var interactor: LogInInteractor! {
        return presenter.interactor as! LogInInteractor
    }
    var presenter: LogInPresenter! {
        return viewController.presenter as! LogInPresenter
    }
    var router: LogInRouter! {
        return presenter.router as! LogInRouter
    }
    
    override func setUp() {
        super.setUp()

        viewController = LogInViewControllerFactory.controller()

        module = LogInModule()
        module.configure(viewController: viewController)
    }
    
    override func tearDown() {
        
        module = nil
        viewController = nil
        super.tearDown()
    }

    func testThatViewControllerHasRightPresenter() {

        XCTAssertNotNil(viewController.presenter)
        XCTAssertTrue(type(of: viewController.presenter!) == LogInPresenter.self)
    }

    func testThatViewControllerIsAViewForPresenter() {

        XCTAssertTrue(presenter.view === viewController)
    }

    func testThatPresenterHasRightRouter() {

        XCTAssertNotNil(presenter.router)
        XCTAssertTrue(type(of: presenter.router!) == LogInRouter.self)
    }

    func testThatPresenterHasRightInteractor() {

        XCTAssertNotNil(presenter.interactor)
        XCTAssertTrue(type(of: presenter.interactor!) == LogInInteractor.self)
    }

    func testThatPresenterIsAnOutputForInteractor() {

        XCTAssertNotNil(interactor.output)
        XCTAssertTrue(interactor.output === presenter)
    }

    func testThatRouterHasRightViewController() {

        XCTAssertNotNil(router.viewController)
        XCTAssertTrue(router.viewController === viewController)
    }
}
