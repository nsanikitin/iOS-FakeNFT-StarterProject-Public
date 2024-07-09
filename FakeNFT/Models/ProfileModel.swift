//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Anna on 18.06.2024.
//

import UIKit

struct ProfileModel: Decodable {
    let name: String
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]?
    let likes: [String]
    let id: String
    
    init(name: String = "", avatar: String? = nil, description: String? = nil, website: String? = nil, nfts: [String]? = nil, likes: [String] = [], id: String = "") {
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.nfts = nfts
        self.likes = likes
        self.id = id
    }
}
