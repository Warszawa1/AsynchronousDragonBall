//
//  NetworkError.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode(Int)
    case invalidData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noResponse:
            return "No response from server"
        case .unauthorized:
            return "Authentication required"
        case .unexpectedStatusCode(let code):
            return "Unexpected status code: \(code)"
        case .invalidData:
            return "Invalid data received"
        case .decodingError:
            return "Error decoding data"
        }
    }
}
