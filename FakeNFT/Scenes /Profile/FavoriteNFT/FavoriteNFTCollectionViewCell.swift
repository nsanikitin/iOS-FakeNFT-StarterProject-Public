//
//  FavoriteNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Anna on 22.06.2024.
//

import UIKit

final class FavoriteNFTCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "FavoriteNFTCollectionViewCell"
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let imageButton = UIImage.likesNoActiveImage
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 12
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textAlignment = .left
        label.textColor = .ypBlack
        return label
    }()
    
    private let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = .ypBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func likeButtonTapped() {
        // TODO: Логика для лайка
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        [nftImageView, likeButton, nameLabel, ratingImageView, costLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 80),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: -1),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 2),
            likeButton.widthAnchor.constraint(equalToConstant: 43),
            likeButton.heightAnchor.constraint(equalToConstant: 43),

            ratingImageView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 6),
            ratingImageView.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: ratingImageView.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: ratingImageView.topAnchor, constant: -4),
            
            costLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 8),
            costLabel.leadingAnchor.constraint(equalTo: ratingImageView.leadingAnchor),
        ])
    }
    
    func configure(with nft: NFTModel) {
        nftImageView.image = UIImage(named: nft.images.first ?? "")
        nameLabel.text = nft.name
        costLabel.text = "\(nft.price) ETH"
        
        switch nft.rating {
        case 1:
            ratingImageView.image = UIImage.stars1
        case 2:
            ratingImageView.image = UIImage.stars2
        case 3:
            ratingImageView.image = UIImage.stars3
        case 4:
            ratingImageView.image = UIImage.stars4
        case 5:
            ratingImageView.image = UIImage.stars5
        default:
            ratingImageView.image = nil
        }
    }
}
