//
//  MockDataProfile.swift
//  FakeNFT
//
//  Created by Anna on 21.06.2024.
//

import Foundation

enum MockData {
    static let nfts: [ProfileNFT] = [
        ProfileNFT(
            createdAt: String(),
            name: "Lilo",
            images: ["nft1_placeholder"],
            rating: 3,
            description: "",
            price: 1.78,
            author: "John Doe",
            id: "1"
        ),
        ProfileNFT(
            createdAt: String(),
            name: "Spring",
            images: ["nft2_placeholder"],
            rating: 3,
            description: "",
            price: 1.78,
            author: "John Doe",
            id: "2"
        ),
        ProfileNFT(
            createdAt: String(),
            name: "April",
            images: ["nft3_placeholder"],
            rating: 3,
            description: "",
            price: 1.78,
            author: "John Doe",
            id: "3"
        )
    ]
    
    static let nftsCollection: [ProfileNFT] = [
        ProfileNFT(
            createdAt: String(),
            name: "Lilo",
            images: ["nft1_placeholderCollection"],
            rating: 3,
            description: "",
            price: 1.78,
            author: "John Doe",
            id: "1"
        ),
        ProfileNFT(
            createdAt: String(),
            name: "Spring",
            images: ["nft2_placeholderCollection"],
            rating: 3,
            description: "",
            price: 1.78,
            author: "John Doe",
            id: "2"
        ),
        ProfileNFT(
            createdAt: String(),
            name: "April",
            images: ["nft3_placeholderCollection"],
            rating: 3,
            description: "",
            price: 1.78,
            author: "John Doe",
            id: "3"
        ),
        ProfileNFT(
            createdAt: String(),
            name: "Archie",
            images: ["nft4_placeholder"],
            rating: 1,
            description: "",
            price: 1.78,
            author: "John Doe",
            id: "4"
        ),
        ProfileNFT(
            createdAt: String(),
            name: "Melissa",
            images: ["nft5_placeholder"],
            rating: 5,
            description: "",
            price: 1.78,
            author: "John Doe",
            id: "5"
        ),
        ProfileNFT(
            createdAt: String(),
            name: "Daisy",
            images: ["nft6_placeholder"],
            rating: 1,
            description: "",
            price: 1.78,
            author: "John Doe",
            id: "6"
        ),
    ]
    
    static let profile = ProfileModel(
        name: "Joaquin Phoenix",
        avatar: "avatarMockProfile",
        description: """
                Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.
                """,
        website: "JoaquinPhoenix.com",
        nfts: ["1", "2"],
        likes: ["2", "3"],
        id: "user123"
    )
}
