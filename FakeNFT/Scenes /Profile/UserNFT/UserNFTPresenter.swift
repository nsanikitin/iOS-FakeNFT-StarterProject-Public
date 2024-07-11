//
//  UserNFTPresenter.swift
//  FakeNFT
//
//  Created by Anna on 07.07.2024.
//

import Foundation

final class UserNFTPresenter {
    private weak var view: UserNFTViewProtocol?
    private(set) var userNfts: [ProfileNFT] = []
    private(set) var profile: ProfileModel = ProfileModel()
    private var nftIds: [String] = []
    private let profileService = ProfileService.shared
    
    init(view: UserNFTViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        loadProfile()
    }
    
    private func loadProfile() {
        view?.showLoading()
        profileService.fetchProfile { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success(let profile):
                    self?.profile = profile
                    self?.loadUserNFTs()
                case .failure(let error):
                    print("Failed to load profile: \(error)")
                }
            }
        }
    }
    
    private func loadUserNFTs() {
        view?.showLoading()
        nftIds = profile.nfts ?? []
        profileService.fetchNFTs(nftIds) { [weak self] nftResult in
            self?.view?.hideLoading()
            DispatchQueue.main.async {
                switch nftResult {
                case .success(let nfts):
                    self?.userNfts = nfts
                    self?.view?.displayUserNFT(nfts)
                case .failure(let error):
                    print("Failed to load NFTs: \(error)")
                }
            }
        }  
    }
    
    func didTapLikeButton(at indexPath: IndexPath) {
        view?.showLoading()
        let nft = userNfts[indexPath.row]
        var updatedLikes = profile.likes
        if let index = updatedLikes.firstIndex(of: nft.id) {
            updatedLikes.remove(at: index)
        } else {
            updatedLikes.append(nft.id)
        }
        let likeRequest = LikeRequest(likes: updatedLikes)
        print("Before updateLikes: \(likeRequest.likes)")
        
        profileService.updateLikes(likeRequest) { [weak self] result in
            self?.view?.hideLoading()
            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.profile = ProfileModel(
                        name: self.profile.name,
                        avatar: self.profile.avatar,
                        description: self.profile.description,
                        website: self.profile.website,
                        nfts: self.profile.nfts,
                        likes: updatedLikes,
                        id: self.profile.id
                    )
                    print("Updated profile: \(self.profile.likes)")
                    self.view?.updateLikes(updatedLikes)
                }
            case .failure(let error):
                print("Error updating likes: \(error)")
            }
        }
    }
    
    func isLiked(nftId: String) -> Bool {
        return profile.likes.contains(nftId)
    }
}
