//
//  AuthRepository.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation
import Combine

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) -> AnyPublisher<Void, Error>
    func logout()
    var isLoggedInPublisher: AnyPublisher<Bool, Never> { get }
}

final class AuthRepository: AuthRepositoryProtocol {
    private let apiClient: APIClientProtocol
    private let secureDataService: SecureDataServiceProtocol
    
    init(apiClient: APIClientProtocol, secureDataService: SecureDataServiceProtocol) {
        self.apiClient = apiClient
        self.secureDataService = secureDataService
    }
    
    func login(email: String, password: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            Task {
                do {
                    let token = try await self.apiClient.loginRequest(email: email, password: password)
                    self.secureDataService.setToken(token)
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func logout() {
        secureDataService.clearToken()
    }
    
    var isLoggedInPublisher: AnyPublisher<Bool, Never> {
        secureDataService.tokenPublisher
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
}

