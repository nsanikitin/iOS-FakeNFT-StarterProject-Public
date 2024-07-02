//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Тася Галкина on 02.07.2024.
//

import Foundation

final class CatalogPresenter {
    
    private let catalogProvider: CatalogProvider = CatalogProviderImpl(networkClient: DefaultNetworkClient())
    private var catalogItems: [CatalogModel] = []
    
    func fetchCollectionAndUpdate(completion: @escaping ([CatalogModel]) -> Void) {
        catalogProvider.getCollection { [weak self] catalogItems in
            guard let self = self else { return }
            self.setCatalogItems(catalogItems)
            completion(catalogItems)
        }
    }
    
    private func setCatalogItems(_ items: [CatalogModel]) {
        catalogItems = items
    }
}
