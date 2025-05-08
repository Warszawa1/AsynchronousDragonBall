//
//  HeroDetailViewModel.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//

// Presentation/HeroDetail/HeroDetailViewModel.swift

import Foundation
import Combine
import MapKit

enum HeroDetailState: Equatable {
    case initial
    case loadingLocations
    case loadingTransformations
    case locationsLoaded
    case transformationsLoaded
    case error(message: String)
    
    static func == (lhs: HeroDetailState, rhs: HeroDetailState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial),
             (.loadingLocations, .loadingLocations),
             (.loadingTransformations, .loadingTransformations),
             (.locationsLoaded, .locationsLoaded),
             (.transformationsLoaded, .transformationsLoaded):
            return true
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

class HeroDetailViewModel {
    // MARK: - Properties
    private let heroRepository: HeroRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Publishers
    @Published private(set) var hero: Hero
    @Published private(set) var locations: [HeroLocation] = []
    @Published private(set) var transformations: [Transformation] = []
    @Published private(set) var state: HeroDetailState = .initial
    
    // MARK: - Triggers
    let loadLocationsTrigger = PassthroughSubject<Void, Never>()
    let loadTransformationsTrigger = PassthroughSubject<Void, Never>()
    
    // MARK: - Initialization
    init(hero: Hero, heroRepository: HeroRepositoryProtocol) {
        self.hero = hero
        self.heroRepository = heroRepository
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // Locations binding
        loadLocationsTrigger
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.state = .loadingLocations
            })
            .flatMap { [weak self] _ -> AnyPublisher<[HeroLocation], Error> in
                guard let self = self else {
                    return Fail(error: NSError(domain: "HeroDetailViewModel", code: 0, userInfo: nil))
                        .eraseToAnyPublisher()
                }
                return self.heroRepository.getHeroLocations(heroId: self.hero.id)
            }
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.state = .error(message: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] locations in
                    self?.locations = locations
                    self?.state = .locationsLoaded
                }
            )
            .store(in: &cancellables)
        
        // Transformations binding
        loadTransformationsTrigger
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.state = .loadingTransformations
            })
            .flatMap { [weak self] _ -> AnyPublisher<[Transformation], Error> in
                guard let self = self else {
                    return Fail(error: NSError(domain: "HeroDetailViewModel", code: 0, userInfo: nil))
                        .eraseToAnyPublisher()
                }
                return self.heroRepository.getHeroTransformations(heroId: self.hero.id)
            }
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.state = .error(message: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] transformations in
                    self?.transformations = transformations
                    self?.state = .transformationsLoaded
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func loadData() {
        loadLocationsTrigger.send()
        loadTransformationsTrigger.send()
    }
    
    func getAnnotations() -> [MKPointAnnotation] {
        return locations.compactMap { location in
            guard let coordinate = location.coordinate else { return nil }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = hero.name
            return annotation
        }
    }
}
