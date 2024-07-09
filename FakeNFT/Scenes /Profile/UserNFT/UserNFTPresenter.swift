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
    private var nftIds: [String] = []
    private let profileService = ProfileService.shared
    
    init(view: UserNFTViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        loadUserNFTs()
    }
    
    private func loadUserNFTs() {
        view?.showLoading()
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
}
