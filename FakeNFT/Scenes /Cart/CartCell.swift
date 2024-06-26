//
//  CartCell.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 20.06.2024.
//

import UIKit
import Kingfisher

final class CartCell: UITableViewCell {
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .bodyBold
        return label
    }()
    
    private let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let priceNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .caption2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .bodyBold
        return label
    }()
    
    private let trashButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let image = UIImage(named: "cartDelete")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
        }
        
        button.backgroundColor = .systemBackground
        button.tintColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
        return button
    }()
    
    var deleteAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        contentView.addSubview(itemImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingImageView)
        contentView.addSubview(priceNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(trashButton)
        
        NSLayoutConstraint.activate([
            itemImageView.widthAnchor.constraint(equalToConstant: 108),
            itemImageView.heightAnchor.constraint(equalToConstant: 108),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: itemImageView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 20),
            
            ratingImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ratingImageView.heightAnchor.constraint(equalToConstant: 12),
            ratingImageView.widthAnchor.constraint(equalToConstant: 68),
            
            priceNameLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 12),
            priceNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: priceNameLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            trashButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trashButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            trashButton.widthAnchor.constraint(equalToConstant: 40),
            trashButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupActions() {
        trashButton.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
    }
    
    @objc private func trashButtonTapped() {
        deleteAction?()
    }
    
    func configure(with item: NFTModel, deleteAction: @escaping () -> Void) {
        if let firstImageURL = item.images.first, let url = URL(string: firstImageURL) {
            itemImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        
        nameLabel.text = item.name
        ratingImageView.image = getRatingImage(for: item.rating)
        priceNameLabel.text = "Цена"
        priceLabel.text = "\(item.price) ETH"
        
        self.deleteAction = deleteAction
    }
    
    private func getRatingImage(for rating: Int) -> UIImage {
        switch rating {
        case 1:
            return UIImage(named: "stars1") ?? UIImage()
        case 2:
            return UIImage(named: "stars2") ?? UIImage()
        case 3:
            return UIImage(named: "stars3") ?? UIImage()
        case 4:
            return UIImage(named: "stars4") ?? UIImage()
        case 5:
            return UIImage(named: "stars5") ?? UIImage()
        default:
            return UIImage(named: "stars0") ?? UIImage()
        }
    }
}
