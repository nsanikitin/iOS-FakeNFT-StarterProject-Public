//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Тася Галкина on 07.07.2024.
//

import Foundation
import ProgressHUD

final class CollectionPresenter {
    
    typealias Completion = (Result<Nft, Error>) -> Void
    
    weak var viewController: CollectionDetailsViewController?
    
    private var onLoadCompletion: (([Nft]) -> Void)?
    private var idLikes: Set<String> = []
    private var idAddedToCart: Set<String> = []
    private let nftModel: CatalogModel
    private let nftService: NftService
    private let collectionService: CollectionService
    private var loadedNFTs: [Nft] = []
    private var checkedNftIds: Set<String> = []
    private var fetchingNftLikes: Set<String> = []
    private var checkedNft: Set<String> = []
    private var fetchingNftCart: Set<String> = []
    
    init(nftModel: CatalogModel, nftService: NftService, collectionService: CollectionService) {
        self.nftModel = nftModel
        self.nftService = nftService
        self.collectionService = collectionService
    }
    
    func returnCollectionCell(for index: Int) -> CollectionCellModel {
        let nftForIndex = loadedNFTs[index]
        checkIfNftIsFavorite(nftForIndex.id)
        checkIfNftIsAddedToCart(nftForIndex.id)
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
    
    private func checkIfNftIsFavorite(_ nftId: String) {
        guard !checkedNftIds.contains(nftId), !fetchingNftLikes.contains(nftId) else { return }
        fetchingNftLikes.insert(nftId)
        collectionService.getProfile { [weak self] result in
            guard let self = self else { return }
            defer { self.fetchingNftLikes.remove(nftId) }
            guard !self.checkedNftIds.contains(nftId) else { return }
            self.checkedNftIds.insert(nftId)
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    let isFavorite = profile.likes.contains(nftId)
                    self.viewController?.updateLikeButtonColor(isLiked: isFavorite, for: nftId)
                    
                case .failure(_):
                    self.viewController?.showError(ErrorModel(message: "Ошибка",
                                                              actionText: "Попробовать еще раз",
                                                              action:  { self.checkIfNftIsFavorite(nftId) }))
                }
            }
        }
    }
    
    private func checkIfNftIsAddedToCart(_ nftId: String) {
        guard !checkedNft.contains(nftId), !fetchingNftCart.contains(nftId) else { return }
        fetchingNftCart.insert(nftId)
        collectionService.getCart { [weak self] result in
            guard let self = self else { return }
            defer { self.fetchingNftCart.remove(nftId) }
            guard !self.checkedNft.contains(nftId) else { return }
            self.checkedNft.insert(nftId)
            DispatchQueue.main.async {
                switch result {
                case .success(let cart):
                    let isAddedToCart = cart.nfts.contains(nftId)
                    
                    if isAddedToCart {
                        self.viewController?.updateCartButtonImage(isAddedToCart: true, for: nftId)
                    }
                case .failure(_):
                    self.viewController?.showError(ErrorModel(message: "Ошибка",
                                                              actionText: "Попробовать еще раз",
                                                              action: { self.checkIfNftIsAddedToCart(nftId) }))
                }
            }
        }
    }
    
    func processNFTsLoading() {
        for id in nftModel.nfts {
            loadNftById(id: id)
        }
    }
    
    private func loadNftById(id: String) {
        nftService.loadNft(id: id) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let nft):
                    self.loadedNFTs.append(nft)
                    self.onLoadCompletion?(self.loadedNFTs)
                case .failure(_):
                    self.viewController?.showError(ErrorModel(message: "Ошибка",
                                                              actionText: "Попробовать еще раз",
                                                              action: {self.loadNftById(id: id)}))
                }
            }
        }
    }
    
    func setOnLoadCompletion(_ completion: @escaping ([Nft]) -> Void) {
        onLoadCompletion = completion
    }
    
    func changeLike(nftID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        ProgressHUD.show()
        
        CollectionService.shared.getProfile { [weak self] result in
            guard let self = self else { return }
            defer { ProgressHUD.dismiss() }
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.handleLikeChange(nftID: nftID, profile: model, completion: completion)
                case .failure(let error):
                    self.viewController?.showError(ErrorModel(message: "Ошибка",
                                                              actionText: "Попробовать еще раз",
                                                              action: { self.changeLike(nftID: nftID, completion: completion) }))
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func handleLikeChange(nftID: String, profile: ProfileModel, completion: @escaping (Result<Bool, Error>) -> Void) {
        var likes = profile.likes
        let isAdded: Bool
        
        if likes.contains(nftID) {
            likes.removeAll { $0 == nftID }
            isAdded = false
        } else {
            likes.append(nftID)
            isAdded = true
        }
        
        CollectionService.shared.changeLike(newLikes: likes, profile: profile) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.handleLikeSuccess(nftID: nftID, isAdded: isAdded, completion: completion)
                case .failure(let error):
                    self.viewController?.showError(ErrorModel(message: "Ошибка",
                                                              actionText: "Попробовать еще раз",
                                                              action: { self.handleLikeChange(nftID: nftID, profile: profile, completion: completion) }))
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func handleLikeSuccess(nftID: String, isAdded: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        NotificationCenter.default.post(name: NSNotification.Name("LikeUpdated"), object: nil, userInfo: ["nftID": nftID, "isAdded": isAdded])
        completion(.success(isAdded))
    }
    
    func changeCart(nftID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        ProgressHUD.show()
        
        CollectionService.shared.getCart { [weak self] result in
            guard let self = self else { return }
            defer { ProgressHUD.dismiss() }
            DispatchQueue.main.async {
                switch result {
                case .success(let cart):
                    self.handleCartChange(nftID: nftID, cart: cart, completion: completion)
                case .failure(let error):
                    self.viewController?.showError(ErrorModel(message: "Ошибка",
                                                              actionText: "Попробовать еще раз",
                                                              action: { self.changeCart(nftID: nftID, completion: completion) }))
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func handleCartChange(nftID: String, cart: Cart, completion: @escaping (Result<Bool, Error>) -> Void) {
        var updatedCart = cart.nfts
        let isAdded: Bool
        
        if updatedCart.contains(nftID) {
            updatedCart.removeAll { $0 == nftID }
            isAdded = false
        } else {
            updatedCart.append(nftID)
            isAdded = true
        }
        
        CollectionService.shared.changeCart(newCart: updatedCart, cart: cart) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.handleCartSuccess(isAdded: isAdded, completion: completion)
                case .failure(let error):
                    self.viewController?.showError(ErrorModel(message: "Ошибка",
                                                              actionText: "Попробовать еще раз",
                                                              action: { self.handleCartChange(nftID: nftID, cart: cart, completion: completion) }))
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func handleCartSuccess(isAdded: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil, userInfo: [:])
        completion(.success(isAdded))
    }
}


