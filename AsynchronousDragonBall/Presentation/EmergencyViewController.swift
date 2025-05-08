//
//  EmergencyViewController.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//

import UIKit

class EmergencyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("EmergencyViewController: viewDidLoad called")
        
        // Force bright background and text
        view.backgroundColor = .red
        
        // Add a really visible label
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "EMERGENCY SCREEN"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Add a button to navigate to login
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("GO TO LOGIN", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = .white
        button.setTitleColor(.red, for: .normal)
        button.layer.cornerRadius = 10
    
        button.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("EmergencyViewController: viewDidAppear called")
    }
    
    @objc func goToLogin() {
        print("EmergencyViewController: goToLogin called")
        
        // Create dependencies
        let secureDataService = SecureDataService.shared
        let apiClient = APIClient(secureDataService: secureDataService)
        let authRepository = AuthRepository(apiClient: apiClient, secureDataService: secureDataService)
        
        // Create view model
        let loginViewModel = LoginViewModel(authRepository: authRepository)
        
        // Create and navigate to view controller
        let loginVC = LoginViewController(viewModel: loginViewModel)
        
        // Present modally
        let navController = UINavigationController(rootViewController: loginVC)
        present(navController, animated: true)
    }
}
