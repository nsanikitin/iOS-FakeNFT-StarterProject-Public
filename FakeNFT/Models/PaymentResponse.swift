//
//  PaymentResponse.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 02.07.2024.
//

struct PaymentResponse: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
