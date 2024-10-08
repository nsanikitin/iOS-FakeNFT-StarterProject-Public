//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Тася Галкина on 30.06.2024.
//

import Foundation
import UIKit
import Kingfisher

final class CatalogCell: UITableViewCell {
    
    static let reuseIdentifier = "CatalogCell"
    
    let collectionCover = UIImageView()
    let collectionTitle = UILabel()
    var collectionImage = UIImage()
    let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    private func configureCollectionCover() {
        contentView.addSubview(collectionCover)
        
        collectionCover.contentMode = .scaleAspectFill
        collectionCover.layer.masksToBounds = true
        collectionCover.layer.cornerRadius = 12
        collectionCover.image = collectionImage
        collectionCover.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionCover.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            collectionCover.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionCover.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionCover.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    private func configureCollectionImage() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        gradientLayer.colors = [
            UIColor(hexString: "#AEAFB4").withAlphaComponent(1.0).cgColor,
            UIColor(hexString: "#AEAFB4").withAlphaComponent(0.3).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        gradientLayer.render(in: context)
        collectionImage = UIGraphicsGetImageFromCurrentImageContext() ?? .cartImage0 // test image
    }
    
    private func configureCollectionTitle() {
        contentView.addSubview(collectionTitle)
        
        collectionTitle.numberOfLines = 0
        collectionTitle.textColor = .ypBlack
        collectionTitle.font = .bodyBold
        collectionTitle.text = "Empty catalog (0)"
        
        collectionTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionTitle.topAnchor.constraint(equalTo: collectionCover.bottomAnchor, constant: 4),
            collectionTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func configureLoadingIndicator() {
        contentView.addSubview(loadingIndicator)
        
        loadingIndicator.hidesWhenStopped = true
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: collectionCover.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: collectionCover.centerYAnchor)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        configureCollectionImage()
        configureCollectionCover()
        configureCollectionTitle()
        configureLoadingIndicator()
    }
    
    func configure(with catalog: CatalogModel, imageLoader: ImageLoader) {
        loadingIndicator.startAnimating()
        if let url = URL(string: catalog.cover) {
            imageLoader.loadImage(from: url) { [weak self] image in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.loadingIndicator.stopAnimating()
                    self.collectionCover.image = image ?? self.collectionImage
                }
            }
        } else {
            loadingIndicator.stopAnimating()
            collectionCover.image = collectionImage
        }
        collectionTitle.text = "\(catalog.name) (\(catalog.count))"
    }
}
