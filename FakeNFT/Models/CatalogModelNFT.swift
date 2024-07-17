//
//  CatalogModelNFT.swift
//  FakeNFT
//
//  Created by Тася Галкина on 18.07.2024.
//

import Foundation
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
