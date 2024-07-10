//
//  CollectionDetailsViewController.swift
//  FakeNFT
//
//  Created by Тася Галкина on 02.07.2024.
//

import Foundation
import UIKit
import SafariServices

final class CollectionDetailsViewController: UIViewController, ErrorView {
    
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
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    let collectionOwnerTitle = UILabel()
    let authorTitle = UILabel()
    let descriptionNFT = UILabel()
    let scrollView = UIScrollView()
    var containerView = UIView()
    
    let nftCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let presenter: CollectionPresenter
    private var nfts: [Nft] = []
    private var nftCollectionViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        configureScrollView()
        configureСontainerView()
        configureCollectionImage()
        configureCollectionCover()
        configureCollectionTitle()
        configureBackButton()
        configureCollectionOwnerTitle()
        configureAuthorTitle()
        configureDescriptionNFT()
        configureNftCollection()
        
        configureLoadingIndicator()
        
        presenter.viewController = self
        presenter.setOnLoadCompletion { [weak self] nfts in
            self?.nfts = nfts
            self?.nftCollection.reloadData()
        }
        presenter.processNFTsLoading()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nftCollection.layoutIfNeeded()
        nftCollectionViewHeightConstraint?.constant = nftCollection.contentSize.height
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -60),
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
    
    private func configureCollectionOwnerTitle() {
        containerView.addSubview(collectionOwnerTitle)
        
        collectionOwnerTitle.numberOfLines = 0
        collectionOwnerTitle.font = .caption2
        collectionOwnerTitle.textColor = .ypBlack
        collectionOwnerTitle.text = "Автор коллекции: "
        
        collectionOwnerTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionOwnerTitle.topAnchor.constraint(equalTo: collectionTitle.bottomAnchor, constant: 13),
            collectionOwnerTitle.leadingAnchor.constraint(equalTo: collectionTitle.leadingAnchor)
        ])
    }
    
    private func configureAuthorTitle() {
        containerView.addSubview(authorTitle)
        
        authorTitle.numberOfLines = 0
        authorTitle.font = .caption1
        authorTitle.textColor = .ypBlueUniversal
        authorTitle.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(authorLinkTapped))
        authorTitle.addGestureRecognizer(tapGesture)
        
        authorTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            authorTitle.leadingAnchor.constraint(equalTo: collectionOwnerTitle.trailingAnchor, constant: 4),
            authorTitle.bottomAnchor.constraint(equalTo: collectionOwnerTitle.bottomAnchor),
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
            descriptionNFT.topAnchor.constraint(equalTo: collectionOwnerTitle.bottomAnchor, constant: 5),
            descriptionNFT.leadingAnchor.constraint(equalTo: collectionTitle.leadingAnchor),
            descriptionNFT.trailingAnchor.constraint(equalTo: collectionTitle.trailingAnchor)
        ])
    }
    
    private func configureLoadingIndicator() {
        containerView.addSubview(loadingIndicator)
        
        loadingIndicator.hidesWhenStopped = true
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureNftCollection() {
        containerView.addSubview(nftCollection)
        
        nftCollection.isScrollEnabled = false
        nftCollection.dataSource = self
        nftCollection.delegate = self
        nftCollection.backgroundColor = .ypWhite
        nftCollection.register(
            CollectionNftCell.self,
            forCellWithReuseIdentifier: CollectionNftCell.reuseIdentifier
        )
        nftCollectionViewHeightConstraint = nftCollection.heightAnchor.constraint(equalToConstant: 0)
        nftCollectionViewHeightConstraint?.isActive = true
        
        nftCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nftCollection.topAnchor.constraint(equalTo: descriptionNFT.bottomAnchor, constant: 24),
            nftCollection.leadingAnchor.constraint(equalTo: collectionTitle.leadingAnchor),
            nftCollection.trailingAnchor.constraint(equalTo: collectionTitle.trailingAnchor),
            nftCollection.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor)
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
        authorTitle.text = catalog.author
        descriptionNFT.text = catalog.description
        nftCollection.reloadData()
    }
    
    init(presenter: CollectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func authorLinkTapped() {
        if let url = URL(string: "https://practicum.yandex.ru/ios-developer/") {
            let webViewController = WebViewController(urlName: url)
            webViewController.modalPresentationStyle = .fullScreen
            present(webViewController, animated: true)
        }
    }
}

extension CollectionDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  nfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionNftCell.reuseIdentifier,
            for: indexPath) as? CollectionNftCell else {
            return UICollectionViewCell()
        }
        let nft = presenter.returnCollectionCell(for: indexPath.row)
        cell.configure(data: nft)
        return cell
    }
}

extension CollectionDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interItemSpacing: CGFloat = 10
        let width = (collectionView.bounds.width - 2 * interItemSpacing) / 3
        return CGSize(width: width, height: 202)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
