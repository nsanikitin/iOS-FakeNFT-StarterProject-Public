//
//  FavoriteNFTViewController.swift
//  FakeNFT
//
//  Created by Anna on 21.06.2024.
//

import UIKit

protocol FavoriteNFTViewProtocol: AnyObject {
    func displayFavoriteNFT(_ favoriteNfts: [ProfileNFT]?)
    func showLoading()
    func hideLoading()
}

final class FavoriteNFTViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var presenter: FavoriteNFTPresenter?
    
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
        presenter = FavoriteNFTPresenter(view: self)
        setupUI()
        setupNavigationItem()
        collectionView.delegate = self
        collectionView.dataSource = self
        presenter?.viewDidLoad()
    }
    
    // MARK: - Public Functions
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Functions
    
    private func updateUI() {
        guard let presenter = presenter else { return }
        
        if presenter.favoriteNfts.isEmpty {
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
}

// MARK: - UICollectionViewDataSource
extension FavoriteNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.favoriteNfts.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteNFTCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? FavoriteNFTCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        
//        let nft = favoriteNfts[indexPath.row]
        //        let isLiked = profile.likes.contains(nft.id)
        //        cell.configure(with: nft, isLiked: isLiked)
        
        if let nft = presenter?.favoriteNfts[indexPath.row] {
            let isLiked = presenter?.profile.likes.contains(nft.id) ?? false
            cell.configure(with: nft, isLiked: isLiked)
        }
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
        guard let nft = presenter?.favoriteNfts[indexPath.row] else { return }
        presenter?.updateLikes(for: nft)

//        let nft = favoriteNfts[indexPath.row]
//        updateLikes(for: nft)
    }
}

extension FavoriteNFTViewController: FavoriteNFTViewProtocol {
    func displayFavoriteNFT(_ favoriteNfts: [ProfileNFT]?) {
        updateUI()
    }
    
    func showLoading() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoading() {
        UIBlockingProgressHUD.dismiss()
    }
}
