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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catalogTableView.delegate = self
        catalogTableView.dataSource = self
        
        fetchCollection()
        configureFilterButton()
        configureCatalogTableView()
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
    
    @objc
    private func tapFiltersButton() {
        print("TODO in Module3")
    }
    
    private func fetchCollection() {
        presenter.fetchCollectionAndUpdate { [weak self] catalogItems in
            guard let self = self else { return }
            self.catalogItems = catalogItems
            self.catalogTableView.reloadData()
        }
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let collectionDetailsVC = CollectionDetailsViewController()
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
