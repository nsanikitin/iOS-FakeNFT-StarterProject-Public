//
//  CatalogModel.swift
//  FakeNFT
//
//  Created by Тася Галкина on 01.07.2024.
//

import Foundation

struct CatalogModel: Codable {
    let name: String
    let cover: String
    let nfts: [String]
    let id: String
    let description: String
    let author: String
    var count: Int {
        nfts.count
    }
}
