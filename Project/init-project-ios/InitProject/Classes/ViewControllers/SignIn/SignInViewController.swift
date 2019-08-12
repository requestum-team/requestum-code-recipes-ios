//
//  SignInViewController.swift
//  
//
//  Created by Requestum on 7/11/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import UIKit

final class SignInViewController: BaseViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - Private property
    
    fileprivate let authAPIClient: AuthAPIClientProvider = AuthAPIClient.shared
    //    fileprivate let userAPIClient: UserAPIClientProvider = UserAPIClient.shared
    //
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Action
    
    @IBAction func sighInAction(_ sender: UIButton) {
    
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
    
    }
}

// MARK: - API

extension SignInViewController {
    
    func getGuestToken() {
        
        authAPIClient.getGuestToken { result in
            switch result {
                
            case .failure(let error):
                AlertManager.showErrorMessage(with: error.message)
                
            case .success( let credential):
                do {
                    try App.userSession.setGuestToken(with: credential)
                    
                } catch {
                    print(error.localizedDescription) // TODO: Add correct error handler
                }
            }
        }
    }
    
    fileprivate func signIn(with data: SignInData) {
        
        Loader.show()
        authAPIClient.signIn(with: data) { [weak self] result in
            Loader.hide()
            switch result {
                
            case .failure(let error):
                AlertManager.showErrorMessage(with: error.message)
                
            case .success( let credential):
                do {
                    try App.userSession.activate(with: credential)
//                    self?.getMe()
                } catch {
                    print(error.localizedDescription) // TODO: Add correct error handler
                }
            }
        }
    }
}
