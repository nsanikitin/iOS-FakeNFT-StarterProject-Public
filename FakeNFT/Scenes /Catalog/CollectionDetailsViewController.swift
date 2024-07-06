//
//  CollectionDetailsViewController.swift
//  FakeNFT
//
//  Created by Тася Галкина on 02.07.2024.
//

import Foundation
import UIKit

final class CollectionDetailsViewController: UIViewController {
    
    var collection: CatalogModel? {
        didSet {
            if let collection = collection {
                configure(with: collection,
                          imageLoader: CatalogProviderImpl(networkClient: DefaultNetworkClient())
                )
            }
        }
    }
    
    let backButton = UIButton()
    let collectionCover = UIImageView()
    let collectionTitle = UILabel()
    var collectionImage = UIImage()
    let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    let authorTitle = UILabel()
    let descriptionNFT = UILabel()
    let scrollView = UIScrollView()
    var containerView = UIView()
    
    private var nftCollectionViewHeightConstraint: NSLayoutConstraint?
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureСontainerView() {
        scrollView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func configureBackButton() {
        containerView.addSubview(backButton)
        
        backButton.setImage(UIImage(named: "backward")?.withTintColor(.ypBlack), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configureCollectionCover() {
        containerView.addSubview(collectionCover)
        
        collectionCover.contentMode = .scaleAspectFill
        collectionCover.layer.masksToBounds = true
        collectionCover.layer.cornerRadius = 12
        collectionCover.image = collectionImage
        collectionCover.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        collectionCover.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionCover.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionCover.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionCover.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionCover.heightAnchor.constraint(equalToConstant: 310)
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
        containerView.addSubview(collectionTitle)
        
        collectionTitle.numberOfLines = 0
        collectionTitle.textColor = .ypBlack
        collectionTitle.font = .headline3
        
        collectionTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionTitle.topAnchor.constraint(equalTo: collectionCover.bottomAnchor, constant: 16),
            collectionTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            collectionTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureAuthorTitle() {
        containerView.addSubview(authorTitle)
        
        authorTitle.numberOfLines = 0
        authorTitle.textColor = .ypBlack
        authorTitle.font = .caption2
        
        authorTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            authorTitle.topAnchor.constraint(equalTo: collectionTitle.bottomAnchor, constant: 13),
            authorTitle.leadingAnchor.constraint(equalTo: collectionTitle.leadingAnchor),
            authorTitle.trailingAnchor.constraint(equalTo: collectionTitle.trailingAnchor)
        ])
    }
    
    private func configureDescriptionNFT() {
        containerView.addSubview(descriptionNFT)
        
        descriptionNFT.numberOfLines = 0
        descriptionNFT.lineBreakMode = .byWordWrapping
        descriptionNFT.textColor = .ypBlack
        descriptionNFT.font = .caption2
        
        descriptionNFT.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionNFT.topAnchor.constraint(equalTo: authorTitle.bottomAnchor, constant: 5),
            descriptionNFT.leadingAnchor.constraint(equalTo: collectionTitle.leadingAnchor),
            descriptionNFT.trailingAnchor.constraint(equalTo: collectionTitle.trailingAnchor)
        ])
    }
    
    private func configureLoadingIndicator() {
        containerView.addSubview(loadingIndicator)
        
        loadingIndicator.hidesWhenStopped = true
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
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
        collectionTitle.text = catalog.name
        authorTitle.text = "Автор коллекции: \(catalog.author)"
        descriptionNFT.text = catalog.description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        configureScrollView()
        configureСontainerView()
        configureCollectionImage()
        configureCollectionCover()
        configureCollectionTitle()
        configureBackButton()
        configureLoadingIndicator()
        configureAuthorTitle()
        configureDescriptionNFT()
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
