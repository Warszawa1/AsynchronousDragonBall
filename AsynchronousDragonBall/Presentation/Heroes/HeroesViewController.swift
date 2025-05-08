//
//  HeroesViewController.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//


import UIKit
import Combine

class HeroesViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: HeroesViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    init(viewModel: HeroesViewModel) {
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
        setupCollectionView()
        setupBindings()
        
        // Load heroes
        viewModel.loadHeroes()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "heroes.title".localized
        view.backgroundColor = .systemBackground
        
        // Add logout button
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        navigationItem.rightBarButtonItem = logoutButton
        
        // Add subviews
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCollectionView() {
        // Register cell
        collectionView.register(HeroCell.self, forCellWithReuseIdentifier: HeroCell.identifier)
        
        // Set delegate and data source
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Configure layout
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    private func setupBindings() {
        // Observe heroes array for changes
        viewModel.$heroes
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        // Observe state for UI updates
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.updateUI(with: state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Updates
    private func updateUI(with state: HeroesState) {
        switch state {
        case .initial, .loaded:
            activityIndicator.stopAnimating()
            collectionView.isHidden = false
            
        case .loading:
            activityIndicator.startAnimating()
            
        case .error(let message):
            activityIndicator.stopAnimating()
            showErrorAlert(message: message)
        }
    }
    
    // MARK: - Actions
    @objc private func logoutTapped() {
        let alert = UIAlertController(
            title: "logout.confirm.title".localized,
            message: "logout.confirm.message".localized,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "common.cancel".localized,
            style: .cancel
        ))
        
        alert.addAction(UIAlertAction(
            title: "logout.confirm.button".localized,
            style: .destructive,
            handler: { [weak self] _ in
                self?.viewModel.logoutTrigger.send()
                
                // Navigate to login
                let loginVC = LoginViewController()
                self?.navigationController?.setViewControllers([loginVC], animated: true)
            }
        ))
        
        present(alert, animated: true)
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

// MARK: - UICollectionViewDataSource
extension HeroesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.heroes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCell.identifier, for: indexPath) as? HeroCell,
              let hero = viewModel.hero(at: indexPath.row) else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: hero)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HeroesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hero = viewModel.hero(at: indexPath.row) else { return }
        
        // Navigate to hero detail
        let detailViewModel = HeroDetailViewModel(hero: hero)
        let detailVC = HeroDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HeroesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 2 // 2 columns with margins
        return CGSize(width: width, height: width * 1.5) // Aspect ratio 2:3
    }
}
