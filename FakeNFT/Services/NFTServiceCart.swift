//
//  NFTServiceCart.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 23.06.2024.
//

import Foundation

class NFTServiceCart {
    private let networkClient: NetworkClientCart

    init(networkClient: NetworkClientCart) {
        self.networkClient = networkClient
    }

    func loadNFTs(completion: @escaping (Result<[NFTModel], Error>) -> Void) {
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/nft") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("61d3c8db-a147-4ae1-87cc-74329c18ff32", forHTTPHeaderField: "X-Practicum-Mobile-Token")

        networkClient.send(request: request, type: [NFTModel].self) { result in
            switch result {
            case .success(let nftList):
                let limitedNftList = Array(nftList.prefix(5))
                completion(.success(limitedNftList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
