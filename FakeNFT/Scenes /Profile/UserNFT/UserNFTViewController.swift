//
//  UserNFTViewController.swift
//  FakeNFT
//
//  Created by Anna on 21.06.2024.
//

import UIKit

final class UserNFTViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.register(
        UserNFTTableViewCell.self,
        forCellReuseIdentifier: UserNFTTableViewCell.reuseIdentifier
        )
        return tableView
    }()
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = .ypBlack
        label.text = "У Вас ещё нет NFT"
        return label
    }()
    
    private var userNfts: [ProfileNFT] = []
 
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationItem()
        tableView.dataSource = self
        tableView.delegate = self
        loadProfileAndNFTs()
        updateUI()
    }
    
    // MARK: - Public Functions
    
    @objc func sortButtonTapped() {
        // TODO: Реализация функции сортировки
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Functions
    
    func updateUI() {
        if userNfts.isEmpty {
            print("No NFTs to display")
            placeHolderLabel.isHidden = false
            tableView.isHidden = true
        } else {
            placeHolderLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    private func loadProfileAndNFTs() {
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let nfts = ProfileService.shared.userNfts {
                        self?.userNfts = nfts
                        self?.updateUI()
                    }
                case .failure(let error):
                    print("Failed to load profile: \(error)")
                }
            }
        }
    }
 
    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        [placeHolderLabel, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            placeHolderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationItem() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .ypWhite
        navigationItem.title = "Мои NFT"
        
        let sortButton = UIBarButtonItem(
            image: UIImage.sortImage,
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        sortButton.tintColor = .ypBlack
        navigationItem.rightBarButtonItem = sortButton
        
        let backButton = UIBarButtonItem(
            image: UIImage.backwardImage,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = backButton
    }
}

// MARK: - UITableViewDataSource

extension UserNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserNFTTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? UserNFTTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        let nft = userNfts[indexPath.row]
        cell.configure(with: nft)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension UserNFTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
