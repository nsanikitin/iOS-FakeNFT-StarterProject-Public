//
//  MockDataProfile.swift
//  FakeNFT
//
//  Created by Anna on 21.06.2024.
//

import Foundation

struct MockData {
    static let nfts: [NFTModel] = [
        NFTModel(
            createdAt: Date(),
            name: "Lilo",
            images: ["nft1_placeholder"],
            rating: 3,
            description: "",
            price: 1.78,
            author: "John Doe",
            id: "1"
        ),
        NFTModel(
            createdAt: Date(),
            name: "Spring",
            images: ["nft2_placeholder"],
            rating: 3,
            description: "",
            price: 1.78,
            author: "John Doe",
            id: "2"
        ),
        NFTModel(
            createdAt: Date(),
            name: "April",
            images: ["nft3_placeholder"],
            rating: 3,
            description: "",
            price: 1.78,
            author: "John Doe",
            id: "3"
        ),
    ]
    
    static let profile = ProfileModel(
        name: "John Doe",
        avatar: "avatarMockProfile",
        description: "NFT enthusiast and digital artist.",
        website: "https://johndoe.com",
        nfts: ["1", "2"],
        likes: ["2", "3"],
        id: "user123"
    )
}
