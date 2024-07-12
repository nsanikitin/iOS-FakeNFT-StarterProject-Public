//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Anna on 20.06.2024.
//

import UIKit

final class CatalogViewController: UIViewController {
    
    private let presenter = CatalogPresenter()
    private var catalogItems: [CatalogModel] = []
    
    let filterButton = UIButton()
    let catalogTableView = UITableView()
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catalogTableView.delegate = self
        catalogTableView.dataSource = self
        
        configureFilterButton()
        configureCatalogTableView()
        configureLoadingIndicator()
        fetchCollection()
    }
    
    private func configureFilterButton() {
        view.addSubview(filterButton)
        
        filterButton.setImage(UIImage(named: "sort")?.withTintColor(.ypBlack), for: .normal)
        filterButton.addTarget(self, action: #selector(tapFiltersButton), for: .touchUpInside)
        
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            filterButton.heightAnchor.constraint(equalToConstant: 42),
            filterButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func configureCatalogTableView() {
        view.addSubview(catalogTableView)
        
        catalogTableView.separatorStyle = .none
        catalogTableView.register(
            CatalogCell.self,
            forCellReuseIdentifier: CatalogCell.reuseIdentifier
        )
        
        catalogTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            catalogTableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor),
            catalogTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            catalogTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            catalogTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureLoadingIndicator() {
        view.addSubview(loadingIndicator)
        
        loadingIndicator.hidesWhenStopped = true
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureRefreshControl() {
        view.addSubview(refreshControl)
        
        refreshControl.tintColor = .ypBlack
        refreshControl.addTarget(self, action: #selector(refreshCatalog), for: .valueChanged)
    }
    
    @objc
    private func tapFiltersButton() {
        let action = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        action.addAction(UIAlertAction(
            title: "По названию",
            style: .default,
            handler: { [weak self] _ in
                self?.catalogItems = self?.presenter.sortCatalog(by: 1) ?? []
                self?.catalogTableView.reloadData()
            }
        ))
        
        action.addAction(UIAlertAction(
            title: "По количеству NFT",
            style: .default,
            handler: { [weak self] _ in
                self?.catalogItems = self?.presenter.sortCatalog(by: 2) ?? []
                self?.catalogTableView.reloadData()
            }
        ))
        
        action.addAction(UIAlertAction(
            title: "Закрыть",
            style: .cancel
        ))
        
        self.present(action, animated: true)
    }
    
    @objc private func refreshCatalog() {
        fetchCollection()
    }
    
    private func fetchCollection() {
        if !refreshControl.isRefreshing {
            loadingIndicator.startAnimating()
        }
        presenter.fetchCollectionAndUpdate { [weak self] catalogItems in
            self?.loadingIndicator.stopAnimating()
            guard let self = self else { return }
            self.catalogItems = catalogItems
            self.catalogTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let nftService = ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl()
        ).nftService
        let collectionDetailsVC = CollectionDetailsViewController(
            presenter: CollectionPresenter(
                nftModel: catalogItems[indexPath.row],
                nftService: nftService,
                collectionService: CollectionService.shared
            )
        )
        
        collectionDetailsVC.collection = catalogItems[indexPath.row]
        collectionDetailsVC.modalPresentationStyle = .fullScreen
        present(collectionDetailsVC, animated: true, completion: nil)
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalogItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.reuseIdentifier, for: indexPath) as? CatalogCell else {
            return UITableViewCell()
        }
        let catalogItem = catalogItems[indexPath.row]
        cell.configure(with: catalogItem, imageLoader: CatalogProviderImpl(networkClient: DefaultNetworkClient()))
        cell.selectionStyle = .none
        cell.backgroundColor = .ypWhite
        return cell
    }
}
