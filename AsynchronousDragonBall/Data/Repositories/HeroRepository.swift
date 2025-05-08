//
//  HeroRepository.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation
import Combine

protocol HeroRepositoryProtocol {
    func getHeroes() -> AnyPublisher<[Hero], Error>
    func getHeroLocations(heroId: String) -> AnyPublisher<[HeroLocation], Error>
    func getHeroTransformations(heroId: String) -> AnyPublisher<[Transformation], Error>
}

final class HeroRepository: HeroRepositoryProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getHeroes() -> AnyPublisher<[Hero], Error> {
        return Future<[Hero], Error> { promise in
            Task {
                do {
                    let apiHeroes: [ApiHero] = try await self.apiClient.request(endpoint: .heroes, body: ["name": ""])
                    let heroes = apiHeroes.map { $0.toDomain() }
                    promise(.success(heroes))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getHeroLocations(heroId: String) -> AnyPublisher<[HeroLocation], Error> {
        return Future<[HeroLocation], Error> { promise in
            Task {
                do {
                    let apiLocations: [ApiHeroLocation] = try await self.apiClient.request(
                        endpoint: .heroLocations(heroId),
                        body: ["id": heroId]
                    )
                    let locations = apiLocations.map { $0.toDomain() }
                    promise(.success(locations))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getHeroTransformations(heroId: String) -> AnyPublisher<[Transformation], Error> {
        return Future<[Transformation], Error> { promise in
            Task {
                do {
                    let apiTransformations: [ApiTransformation] = try await self.apiClient.request(
                        endpoint: .heroTransformations(heroId),
                        body: ["id": heroId]
                    )
                    let transformations = apiTransformations.map { $0.toDomain() }
                    promise(.success(transformations))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
