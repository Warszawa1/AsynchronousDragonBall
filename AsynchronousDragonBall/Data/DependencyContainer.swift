//
//  DependencyContainer.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()
    
    // Services
    let secureDataService: SecureDataServiceProtocol
    let apiClient: APIClientProtocol
    
    // Repositories
    let authRepository: AuthRepositoryProtocol
    let heroRepository: HeroRepositoryProtocol
    
    private init() {
        // Create services
        secureDataService = SecureDataService.shared
        apiClient = APIClient(secureDataService: secureDataService)
        
        // Create repositories
        authRepository = AuthRepository(apiClient: apiClient, secureDataService: secureDataService)
        heroRepository = HeroRepository(apiClient: apiClient)
    }
    
    // Factory methods for view models
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authRepository: authRepository)
    }
    
    func makeHeroesViewModel() -> HeroesViewModel {
        return HeroesViewModel(heroRepository: heroRepository, authRepository: authRepository)
    }
    
    func makeHeroDetailViewModel(hero: Hero) -> HeroDetailViewModel {
        return HeroDetailViewModel(hero: hero, heroRepository: heroRepository)
    }
}
