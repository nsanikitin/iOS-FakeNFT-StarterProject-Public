//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Тася Галкина on 07.07.2024.
//

import Foundation

final class CollectionPresenter {
    
    typealias Completion = (Result<Nft, Error>) -> Void
    
    weak var viewController: CollectionDetailsViewController?
    
    private var onLoadCompletion: (([Nft]) -> Void)?
    private var idLikes: Set<String> = []
    private var idAddedToCart: Set<String> = []
    private let nftModel: CatalogModel
    private let nftService: NftService
    private var loadedNFTs: [Nft] = []
    
    init(nftModel: CatalogModel, nftService: NftService) {
        self.nftModel = nftModel
        self.nftService = nftService
    }
    
    func returnCollectionCell(for index: Int) -> CollectionCellModel {
        let nftForIndex = loadedNFTs[index]
        return CollectionCellModel(image: nftForIndex.images[0],
                                   name: nftForIndex.name,
                                   rating: nftForIndex.rating,
                                   price: nftForIndex.price,
                                   isLiked: self.isLiked(nftForIndex.id),
                                   isAddedToCart: self.isAddedToCart(nftForIndex.id),
                                   id: nftForIndex.id
        )
    }
    
    func isLiked(_ idOfCell: String) -> Bool {
        idLikes.contains(idOfCell)
    }
    
    func isAddedToCart(_ idOfCell: String) -> Bool {
        idAddedToCart.contains(idOfCell)
    }
    
    func processNFTsLoading() {
        for id in nftModel.nfts {
            loadNftById(id: id)
        }
    }
    
    private func loadNftById(id: String) {
        nftService.loadNft(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nft):
                self.loadedNFTs.append(nft)
                self.onLoadCompletion?(self.loadedNFTs)
            case .failure(_):
                viewController?.showError(ErrorModel(message: "Ошибка", actionText: "Попробовать еще раз", action: {self.loadNftById(id: id)}))
            }
        }
    }
    
    func setOnLoadCompletion(_ completion: @escaping ([Nft]) -> Void) {
        onLoadCompletion = completion
    }
}
