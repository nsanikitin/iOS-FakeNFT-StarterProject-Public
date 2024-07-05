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
        case id = "id"
        case name = "name"
        case description = "description"
        case price = "price"
        case rating = "rating"
        case author = "author"
        case createdAt = "createdAt"
        case images = "images"
    }
}
