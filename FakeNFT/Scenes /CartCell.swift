//
//  CartCell.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 20.06.2024.
//

import UIKit

class CartCell: UITableViewCell {
    
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
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemYellow
        return label
    }()
    
    let priceNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    let trashButton: UIButton = {
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
        contentView.addSubview(ratingLabel)
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
            
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            priceNameLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 12),
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
        UIView.animate(withDuration: 0.1, animations: {
            self.trashButton.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.trashButton.alpha = 1.0
            }
        }
        deleteAction?()
    }
    
    func configure(with item: NFTModel, deleteAction: @escaping () -> Void) {
        if let imageName = item.images.first {
            itemImageView.image = UIImage(named: imageName)
        }
        nameLabel.text = item.name
        ratingLabel.text = String(repeating: "★", count: item.rating) + String(repeating: "☆", count: 5 - item.rating)
        priceNameLabel.text = "Цена"
        priceLabel.text = "\(item.price) ETH"
        self.deleteAction = deleteAction
    }
}
