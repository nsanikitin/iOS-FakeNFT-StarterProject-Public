//
//  CatalogModelNFT.swift
//  FakeNFT
//
//  Created by Anna on 18.06.2024.
//

import UIKit

struct CatalogModelNFT: Codable {
    let name: String
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]
    let likes: [String]
    let id: String
}
