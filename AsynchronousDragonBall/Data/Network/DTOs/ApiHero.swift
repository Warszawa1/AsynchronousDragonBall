//
//  ApiHero.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

struct ApiHero: Codable {
    let id: String
    var favorite: Bool?
    let name: String?
    let description: String?
    let photo: String?
    
    // Mapper function to domain model
    func toDomain() -> Hero {
        Hero(
            id: id,
            favorite: favorite,
            name: name,
            description: description,
            photo: photo
        )
    }
}
