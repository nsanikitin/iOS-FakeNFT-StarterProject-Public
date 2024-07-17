//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Тася Галкина on 18.07.2024.
//

import Foundation
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
    
    func update(updateLikes: [String]) -> Self {
        .init(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            nfts: nfts,
            likes: updateLikes,
            id: id)
    }
}
