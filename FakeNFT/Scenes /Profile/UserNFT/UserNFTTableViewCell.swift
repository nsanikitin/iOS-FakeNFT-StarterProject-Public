//
//  UserNFTTableViewCell.swift
//  FakeNFT
//
//  Created by Anna on 21.06.2024.
//

import UIKit
import Kingfisher

protocol UserNFTTableViewCellDelegate: AnyObject {
    func didTapLikeButton(_ cell: UserNFTTableViewCell)
}

final class UserNFTTableViewCell: UITableViewCell {
    static let reuseIdentifier = "UserNFTTableViewCell"
    weak var delegate: UserNFTTableViewCellDelegate?
    
    // MARK: - Private Properties
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        return view
    }()
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let imageButton = UIImage.likesNoActiveImage
        let button = UIButton(type: .custom)
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textAlignment = .left
        label.textColor = .ypBlack
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .ypBlack
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .ypBlack
        label.text = "Цена"
        return label
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = .ypBlack
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    
    @objc func likeButtonTapped() {
        delegate?.didTapLikeButton(self)
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        [nftImageView, likeButton, nameLabel, ratingImageView, authorLabel, priceLabel, costLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nftImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            nftImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),

            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),

            priceLabel.leadingAnchor.constraint(equalTo: costLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 65),

            costLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            costLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39),
            costLabel.heightAnchor.constraint(equalToConstant: 22),

            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(equalToConstant: 78),
            nameLabel.bottomAnchor.constraint(equalTo: ratingImageView.topAnchor, constant: -4),
            
            ratingImageView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 16),
            ratingImageView.centerYAnchor.constraint(equalTo: nftImageView.centerYAnchor),
            
            authorLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            authorLabel.widthAnchor.constraint(equalToConstant: 78),
            authorLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 4),
        ])
    }
    
    func configure(with nft: ProfileNFT, isLiked: Bool) {
        if let firstImageURL = nft.images.first, let url = URL(string: firstImageURL) {
            nftImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
                }
        likeButton.setImage(isLiked ? UIImage.likesActiveImage : UIImage.likesNoActiveImage, for: .normal)
        nameLabel.text = nft.name
        setAuthorLabelText(nft.author)
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
    
    private func setAuthorLabelText(_ author: String) {
        let authorName = extractAuthorName(author)
        let fullText = "от \(authorName)"
        let attributedText = NSMutableAttributedString(string: fullText)
        let range = NSRange(location: 0, length: fullText.count)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        authorLabel.attributedText = attributedText
    }
    
    private func extractAuthorName(_ author: String) -> String {
        let prefix = "https://"
        let suffix = ".fakenfts.org/"
        guard author.hasPrefix(prefix), author.hasSuffix(suffix) else {
            return author
        }
        let startIndex = author.index(author.startIndex, offsetBy: prefix.count)
        let endIndex = author.index(author.endIndex, offsetBy: -suffix.count)
        return String(author[startIndex..<endIndex])
    }
}
