//
//  CollectionNftCell.swift
//  FakeNFT
//
//  Created by Тася Галкина on 06.07.2024.
//

import Foundation
import UIKit
import Kingfisher

final class CollectionNftCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CollectionNftCell"
    
    private var itemId: String = ""
    private var isInCart: Bool = false
    private var isLiked: Bool = false
    
    let nftImage = UIImageView()
    let ratingView = UIImageView()
    let nameNFT = UILabel()
    let priceNFT = UILabel()
    let cartButton = UIButton()
    let likeButton = UIButton()
    let containerView = UIView()
    
    private func configureNftImage() {
        contentView.addSubview(nftImage)
        
        nftImage.contentMode = .scaleAspectFit
        nftImage.layer.cornerRadius = 12
        nftImage.layer.masksToBounds = true
        nftImage.image = UIImage(named: "CartImage0")
        
        nftImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nftImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImage.heightAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    private func configureLikeButton() {
        contentView.addSubview(likeButton)
        
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = .white
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    private func configureRatingView() {
        contentView.addSubview(ratingView)
        
        ratingView.image = UIImage(named: "stars3")
        ratingView.contentMode = .scaleAspectFit
        
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: nftImage.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40)
        ])
    }
    
    private func configureNameNFT() {
        containerView.addSubview(nameNFT)
        
        nameNFT.font = .bodyBold
        nameNFT.text = "Archie"
        nameNFT.setContentCompressionResistancePriority(.required, for: .vertical)
        nameNFT.numberOfLines = 2
        nameNFT.adjustsFontSizeToFitWidth = true
        
        nameNFT.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameNFT.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nameNFT.topAnchor.constraint(equalTo: containerView.topAnchor),
            nameNFT.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor)
        ])
    }
    
    private func configurePriceNFT() {
        containerView.addSubview(priceNFT)
        
        priceNFT.font = .systemFont(ofSize: 10, weight: .medium)
        priceNFT.text = "1 ETH"
        
        priceNFT.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            priceNFT.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            priceNFT.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            priceNFT.topAnchor.constraint(equalTo: nameNFT.bottomAnchor, constant: 4),
            priceNFT.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor)
        ])
    }
    
    private func configureCartButton() {
        containerView.addSubview(cartButton)
        
        cartButton.setImage(UIImage(named: "cartDelete"), for: .normal)
        cartButton.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
        
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cartButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cartButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureContainerView() {
        contentView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 5),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -21)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func likeTapped() {
        print("TODO in Module3")
    }
    
    @objc private func cartTapped() {
        print("TODO in Module3")
    }
    
    private func setupConfigure() {
        
        configureNftImage()
        configureLikeButton()
        configureRatingView()
        configureContainerView()
        
        configureCartButton()
        configureNameNFT()
        configurePriceNFT()
    }
    
    func configure(data: CollectionCellModel) {
        nftImage.kf.setImage(with: data.image)
        nameNFT.text = data.name
        setRatingStars(data.rating)
        let priceString = String(format: "%.2f", data.price)
        priceNFT.text = priceString + " ETH"
        itemId = data.id
        setLikeButtonState(isLiked: data.isLiked)
        setCartButtonState(isAdded: data.isAddedToCart)
    }
    
    private func setLikeButtonState(isLiked: Bool) {
        likeButton.tintColor = isLiked ? .ypRedUniversal : UIColor.white
    }
    
    private func setCartButtonState(isAdded: Bool) {
        let imageName = isAdded ? "cartDelete" : "cartEmpty"
        cartButton.setImage(UIImage(named: imageName)?.withTintColor(.label), for: .normal)
    }
    
    private func setRatingStars(_ rating: Int) {
        ratingView.image = UIImage(named: "stars\(rating)")
    }
    
}
