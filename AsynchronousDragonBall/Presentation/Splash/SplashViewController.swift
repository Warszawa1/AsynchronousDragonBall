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
        imageView.image = UIImage(named: "dragonball_logo")
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
            self.checkAuthentication()
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
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
        // Check if user is logged in
        if secureDataService.getToken() != nil {
            navigateToHeroes()
        } else {
            navigateToLogin()
        }
    }
    
    private func navigateToLogin() {
        let loginVC = LoginViewController()
        navigationController?.setViewControllers([loginVC], animated: true)
    }
    
    private func navigateToHeroes() {
        let heroesVC = HeroesViewController()
        navigationController?.setViewControllers([heroesVC], animated: true)
    }
}
