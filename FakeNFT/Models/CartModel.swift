//
//  CartModel.swift
//  FakeNFT
//
//  Created by Тася Галкина on 12.07.2024.
//

import Foundation

struct CartModel: Decodable {
    let id: String
    let nfts: [String]
}
