//
//  FavoriteNFTViewController.swift
//  FakeNFT
//
//  Created by Anna on 21.06.2024.
//

import UIKit

final class FavoriteNFTViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var favoriteNfts: [ProfileNFT] = []
    private var nftIds: [String] = []
    private(set) var profile: ProfileModel = ProfileModel()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
            )
        collectionView.register(
            FavoriteNFTCollectionViewCell.self,
            forCellWithReuseIdentifier: FavoriteNFTCollectionViewCell.reuseIdentifier
        )
        collectionView.backgroundColor = .ypWhite
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = .ypBlack
        label.text = "У Вас ещё нет избранных NFT"
        return label
    }()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationItem()
//        updateUI()
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchProfile()
    }
    
    // MARK: - Public Functions
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Functions
    
    private func updateUI() {
        if favoriteNfts.isEmpty {
            placeHolderLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            placeHolderLabel.isHidden = true
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        [placeHolderLabel, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            placeHolderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationItem() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .ypWhite
        navigationItem.title = "Избранные NFT"
        
        let backButton = UIBarButtonItem(
            image: UIImage.backwardImage,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func fetchProfile() {
        ProfileService.shared.fetchProfile { [weak self] result in
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
        UIBlockingProgressHUD.show()
        let nftIds = profile.likes
        
        ProfileService.shared.fetchFavoriteNFTs(nftIds) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            DispatchQueue.main.async {
                switch result {
                case .success(let nfts):
                    self?.favoriteNfts = nfts
                    self?.updateUI()
                case .failure(let error):
                    print("Failed to load NFTs: \(error)")
                }
            }
        }
    }
    
    private func updateLikes(for nft: ProfileNFT) {
        UIBlockingProgressHUD.show()
        var updatedLikes = profile.likes
        if let index = updatedLikes.firstIndex(of: nft.id) {
            updatedLikes.remove(at: index)
        } 
        
        let likeRequest = LikeRequest(likes: updatedLikes)
        
        ProfileService.shared.updateLikes(likeRequest) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let updatedProfile):
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.profile = updatedProfile
                    if let index = self.favoriteNfts.firstIndex(where: { $0.id == nft.id }) {
                        self.favoriteNfts.remove(at: index)
                    }
                    self.updateUI()
                }
            case .failure(let error):
                print("Error updating likes: \(error)")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FavoriteNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteNfts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteNFTCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? FavoriteNFTCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        let nft = favoriteNfts[indexPath.row]
        let isLiked = profile.likes.contains(nft.id)
        cell.configure(with: nft, isLiked: isLiked)
        cell.delegate = self

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 168, height: 80)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 20
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 16
    }
}

// MARK: - UICollectionViewDelegate
extension FavoriteNFTViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - Extension

extension FavoriteNFTViewController: FavoriteNFTCollectionViewDelegate {
    func didTapLikeButton(_ cell: FavoriteNFTCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let nft = favoriteNfts[indexPath.row]
        updateLikes(for: nft)
    }
    
}
