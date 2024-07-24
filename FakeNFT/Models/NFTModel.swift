//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Anna on 18.06.2024.
//

import UIKit

struct NFTModel: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String?
    let price: Float
    let author: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
            case id
            case name
            case description
            case price
            case rating
            case author
            case createdAt
            case images
        }
}

