//
//  FavoriteNFTPresenter.swift
//  FakeNFT
//
//  Created by Anna on 12.07.2024.
//

import Foundation

final class FavoriteNFTPresenter {
    private weak var view: FavoriteNFTViewProtocol?
    private(set) var favoriteNfts: [ProfileNFT] = []
    private(set) var profile: ProfileModel = ProfileModel()
    private let profileService = ProfileService.shared
    
    init(view: FavoriteNFTViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchProfile()
    }
    
    private func fetchProfile() {
        view?.showLoading()
        profileService.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                self?.fetchFavoriteNFTs()
            case .failure(let error):
                print("Failed to load profile: \(error)")
            }
        }
    }
    
    private func fetchFavoriteNFTs() {
        profileService.fetchFavoriteNFTs(profile.likes) { [weak self] result in
            self?.view?.hideLoading()
            DispatchQueue.main.async {
                switch result {
                case .success(let nfts):
                    self?.favoriteNfts = nfts
                    self?.view?.displayFavoriteNFT(nfts)
                case .failure(let error):
                    print("Failed to load NFTs: \(error)")
                }
            }
        }
    }
    
    func updateLikes(for nft: ProfileNFT) {
        view?.showLoading()
        var updatedLikes = profile.likes
        if let index = updatedLikes.firstIndex(of: nft.id) {
            updatedLikes.remove(at: index)
        }
        
        let likeRequest = LikeRequest(likes: updatedLikes)
        
        profileService.updateLikes(likeRequest) { [weak self] result in
            self?.view?.hideLoading()
            switch result {
            case .success(let updatedProfile):
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.profile = updatedProfile
                    if let index = self.favoriteNfts.firstIndex(where: { $0.id == nft.id }) {
                        self.favoriteNfts.remove(at: index)
                    }
                    self.view?.displayFavoriteNFT(self.favoriteNfts)
                }
            case .failure(let error):
                print("Error updating likes: \(error)")
            }
        }
    }
}
