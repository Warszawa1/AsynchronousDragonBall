//
//  SplashViewController.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//

// Presentation/Splash/SplashViewController.swift

import UIKit
import Combine

class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let secureDataService = SecureDataService.shared
    
    // MARK: - UI Elements
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "bolt.circle") // Placeholder if you don't have a logo
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Start animation
        activityIndicator.startAnimating()
        
        // Add slight delay for splash screen effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("SplashViewController checking authentication")
            self.checkAuthentication()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SplashViewController: viewDidAppear called")
        print("SplashViewController: view background color is \(view.backgroundColor?.description ?? "nil")")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SplashViewController: viewWillAppear called")
        
        // Force UI elements to be visible
        view.backgroundColor = .systemBackground
        logoImageView.image = UIImage(systemName: "bolt.circle")
        logoImageView.tintColor = .label
    }
    
    // MARK: - Setup
    private func setupUI() {
        print("SplashViewController setting up UI")
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(logoImageView)
        view.addSubview(activityIndicator)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20)
        ])
    }
    
    // MARK: - Navigation
    private func checkAuthentication() {
        // For debugging
        print("Token exists: \(secureDataService.getToken() != nil)")
        
        // Check if user is logged in
        if secureDataService.getToken() != nil {
            navigateToHeroes()
        } else {
            navigateToLogin()
        }
    }
    
    private func navigateToLogin() {
        print("Navigating to login screen")
        
        // Create dependencies
        let secureDataService = SecureDataService.shared
        let apiClient = APIClient(secureDataService: secureDataService)
        let authRepository = AuthRepository(apiClient: apiClient, secureDataService: secureDataService)
        
        // Create view model
        let loginViewModel = LoginViewModel(authRepository: authRepository)
        
        // Create and navigate to view controller
        let loginVC = LoginViewController(viewModel: loginViewModel)
        navigationController?.setViewControllers([loginVC], animated: true)
    }
    
    private func navigateToHeroes() {
        print("Navigating to heroes screen")
        
        // Create dependencies
        let secureDataService = SecureDataService.shared
        let apiClient = APIClient(secureDataService: secureDataService)
        let heroRepository = HeroRepository(apiClient: apiClient)
        let authRepository = AuthRepository(apiClient: apiClient, secureDataService: secureDataService)
        
        // Create view model
        let heroesViewModel = HeroesViewModel(heroRepository: heroRepository, authRepository: authRepository)
        
        // Create and navigate to view controller
        let heroesVC = HeroesViewController(viewModel: heroesViewModel)
        navigationController?.setViewControllers([heroesVC], animated: true)
    }
}
