//
//  LogInViewControllerFactory.swift
//

import Foundation

@testable import 

struct LogInViewControllerFactory {

    static func controller() -> LogInViewController {
        return UIStoryboard(name: "Authorization", bundle: nil).instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
    }
}
