//
//  LoginViewController.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//


import UIKit
import Combine

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "login.title".localized
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "login.email".localized
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "login.password".localized
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("login.button".localized, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        
        // Create a stack view for form elements
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        
        // Constraint setup
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor)
        ])
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupBindings() {
        // Bind text fields to view model
        emailTextField.textPublisher
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        passwordTextField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        // Bind login button to trigger
        loginButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.dismissKeyboard()
                self?.viewModel.loginTrigger.send()
            }
            .store(in: &cancellables)
        
        // Observe state changes
        viewModel.$state
            .sink { [weak self] state in
                self?.updateUI(with: state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Updates
    private func updateUI(with state: LoginState) {
        switch state {
        case .initial:
            activityIndicator.stopAnimating()
            loginButton.isEnabled = true
            loginButton.setTitle("login.button".localized, for: .normal)
            emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
            
        case .loading:
            activityIndicator.startAnimating()
            loginButton.isEnabled = false
            loginButton.setTitle("", for: .normal)
            emailTextField.isEnabled = false
            passwordTextField.isEnabled = false
            
        case .success:
            activityIndicator.stopAnimating()
            navigateToHeroes()
            
        case .error(let message):
            activityIndicator.stopAnimating()
            loginButton.isEnabled = true
            loginButton.setTitle("login.button".localized, for: .normal)
            emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
            showErrorAlert(message: message)
        }
    }
    
    // MARK: - Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Navigation
    private func navigateToHeroes() {
        let heroesVC = HeroesViewController()
        navigationController?.setViewControllers([heroesVC], animated: true)
    }
    
    // MARK: - Helpers
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "common.error".localized,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "common.ok".localized,
            style: .default
        ))
        
        present(alert, animated: true)
    }
}
