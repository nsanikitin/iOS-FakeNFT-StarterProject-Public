//
//  UserNFTViewController.swift
//  FakeNFT
//
//  Created by Anna on 21.06.2024.
//

import UIKit

protocol UserNFTViewProtocol: AnyObject {
    func displayUserNFT(_ userNfts: [ProfileNFT]?)
    func showLoading()
    func hideLoading()
    func updateLikes(_ likes: [String])
    func reloadData()
}

final class UserNFTViewController: UIViewController {
    private var presenter: UserNFTPresenter?
    
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
 
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = UserNFTPresenter(view: self)
        setupUI()
        setupNavigationItem()
        tableView.dataSource = self
        tableView.delegate = self
        presenter?.viewDidLoad()
        updateUI()
    }
    
    // MARK: - Public Functions
    
    @objc func sortButtonTapped() {
        let alert = UIAlertController(
            title: nil,
            message: "Сортировка",
            preferredStyle: .actionSheet
        )
        
        let byPriceAction = UIAlertAction(
            title: "По цене",
            style: .default
        ) { [weak self] _ in
            self?.presenter?.sortNFTs(by: .price)
            }
        
        let byRatingAction = UIAlertAction(
            title: "По рейтингу",
            style: .default
        ) { [weak self] _ in
            self?.presenter?.sortNFTs(by: .rating)
        }
        
        let byNameAction = UIAlertAction(
            title: "По названию",
            style: .default
        ) { [weak self] _ in
            self?.presenter?.sortNFTs(by: .name)
        }
        
        let close = UIAlertAction(
            title: "Закрыть",
            style: .cancel
        )
        
        alert.addAction(byPriceAction)
        alert.addAction(byRatingAction)
        alert.addAction(byNameAction)
        alert.addAction(close)
        
        present(alert, animated: true)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Functions
    
    func updateUI() {
        guard let presenter = presenter else { return }
        
        if presenter.userNfts.isEmpty {
            placeHolderLabel.isHidden = false
            tableView.isHidden = true
        } else {
            placeHolderLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
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
        return presenter?.userNfts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserNFTTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? UserNFTTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        if let nft = presenter?.userNfts[indexPath.row] {
            let isLiked = presenter?.isLiked(nftId: nft.id) ?? false
            cell.configure(with: nft, isLiked: isLiked)
        }
        cell.delegate = self
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

// MARK: - Extensions

extension UserNFTViewController: UserNFTViewProtocol {
    func displayUserNFT(_ userNfts: [ProfileNFT]?) {
        updateUI()
    }
    
    func showLoading() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoading() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func updateLikes(_ likes: [String]) {
        tableView.reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

extension UserNFTViewController: UserNFTTableViewCellDelegate {
    func didTapLikeButton(_ cell: UserNFTTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.didTapLikeButton(at: indexPath)
    }
}
