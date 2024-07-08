//
//  CatalogProvider.swift
//  FakeNFT
//
//  Created by Тася Галкина on 01.07.2024.
//

import Foundation
import Kingfisher
import UIKit

protocol ImageLoader {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

protocol CatalogProvider {
    func getCollection(completion: @escaping ([CatalogModel]) -> Void)
}

final class CatalogProviderImpl: CatalogProvider, ImageLoader {
    
    private var collections: [CatalogModel] = []
    private let networkClient: DefaultNetworkClient
    
    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }
    
    func getCollection(completion: @escaping ([CatalogModel]) -> Void) {
        networkClient.send(request: CollectionsRequest(), type: [CatalogModel].self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nft):
                self.collections = nft
                completion(nft)
            case .failure(let error):
                print("Error fetching NFT collection: \(error)")
                completion([])
            }
        }
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure(let error):
                print("Error loading image: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
