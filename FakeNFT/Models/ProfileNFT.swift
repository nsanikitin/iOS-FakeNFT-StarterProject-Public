//
//  ProfileNFT.swift
//  FakeNFT
//
//  Created by Anna on 03.07.2024.
//

import Foundation

struct ProfileNFT: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case name = "name"
        case images = "images"
        case rating = "rating"
        case description = "description"
        case price = "price"
        case author = "author"
        case id = "id"
    }
}
