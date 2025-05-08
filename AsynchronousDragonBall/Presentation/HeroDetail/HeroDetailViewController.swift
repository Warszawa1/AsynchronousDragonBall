//
//  HeroDetailViewController.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//


import UIKit
import MapKit
import Combine

class HeroDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: HeroDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let transformationsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "detail.transformations".localized
        return label
    }()
    
    private let transformationsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 150)
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let noTransformationsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.text = "detail.noTransformations".localized
        label.isHidden = true
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    init(viewModel: HeroDetailViewModel) {
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
        
        // Load data
        viewModel.loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = viewModel.hero.name
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(heroImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(mapView)
        contentView.addSubview(transformationsLabel)
        contentView.addSubview(transformationsCollectionView)
        contentView.addSubview(noTransformationsLabel)
        view.addSubview(activityIndicator)
        
        // Configure initial values
        nameLabel.text = viewModel.hero.name
        descriptionLabel.text = viewModel.hero.description
        
        // Load hero image
        if let photoURLString = viewModel.hero.photo, let photoURL = URL(string: photoURLString) {
            heroImageView.kf.setImage(
                with: photoURL,
                placeholder: UIImage(systemName: "person.fill"),
                options: [.transition(.fade(0.2))]
            )
        } else {
            heroImageView.image = UIImage(systemName: "person.fill")
        }
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Hero image view
            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            heroImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            heroImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            heroImageView.heightAnchor.constraint(equalTo: heroImageView.widthAnchor),
            
            // Name label
            nameLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Description label
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Map view
            mapView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 200),
            
            // Transformations label
            transformationsLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16),
            transformationsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            transformationsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Transformations collection view
            transformationsCollectionView.topAnchor.constraint(equalTo: transformationsLabel.bottomAnchor, constant: 8),
            transformationsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            transformationsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            transformationsCollectionView.heightAnchor.constraint(equalToConstant: 150),
            transformationsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            // No transformations label
            noTransformationsLabel.topAnchor.constraint(equalTo: transformationsLabel.bottomAnchor, constant: 16),
            noTransformationsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            noTransformationsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            noTransformationsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            // Activity indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCollectionView() {
        // Register cell
        transformationsCollectionView.register(TransformationCell.self, forCellWithReuseIdentifier: TransformationCell.identifier)
        
        // Set delegates
        transformationsCollectionView.delegate = self
        transformationsCollectionView.dataSource = self
    }
    
    private func setupBindings() {
        // Observe hero locations
        viewModel.$locations
            .receive(on: RunLoop.main)
            .sink { [weak self] locations in
                self?.updateMapWithLocations()
            }
            .store(in: &cancellables)
        
        // Observe transformations
        viewModel.$transformations
            .receive(on: RunLoop.main)
            .sink { [weak self] transformations in
                self?.updateTransformationsUI(transformations: transformations)
            }
            .store(in: &cancellables)
        
        // Observe state for loading indicators
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.updateUI(with: state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Updates
    private func updateUI(with state: HeroDetailState) {
        switch state {
        case .initial:
            activityIndicator.stopAnimating()
            
        case .loadingLocations, .loadingTransformations:
            activityIndicator.startAnimating()
            
        case .locationsLoaded, .transformationsLoaded:
            activityIndicator.stopAnimating()
            
        case .error(let message):
            activityIndicator.stopAnimating()
            showErrorAlert(message: message)
        }
    }
    
    private func updateMapWithLocations() {
        // Add annotations to map
        let annotations = viewModel.getAnnotations()
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        
        // Zoom to show all annotations if there are any
        if !annotations.isEmpty {
            mapView.showAnnotations(annotations, animated: true)
        }
    }
    
    private func updateTransformationsUI(transformations: [Transformation]) {
        // Show/hide the appropriate views based on if there are transformations
        if transformations.isEmpty {
            transformationsCollectionView.isHidden = true
            noTransformationsLabel.isHidden = false
        } else {
            transformationsCollectionView.isHidden = false
            noTransformationsLabel.isHidden = true
            transformationsCollectionView.reloadData()
        }
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
    
    private func showTransformationDetail(transformation: Transformation) {
        // Create alert controller to show transformation details
        let alert = UIAlertController(
            title: transformation.name,
            message: transformation.description,
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
extension HeroDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.transformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransformationCell.identifier, for: indexPath) as? TransformationCell else {
            return UICollectionViewCell()
        }
        
        let transformation = viewModel.transformations[indexPath.row]
        cell.configure(with: transformation)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HeroDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transformation = viewModel.transformations[indexPath.row]
        showTransformationDetail(transformation: transformation)
    }
}
