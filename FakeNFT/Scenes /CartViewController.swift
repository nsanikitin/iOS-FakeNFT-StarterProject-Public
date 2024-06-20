//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Anna on 20.06.2024.
//

import UIKit

final class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var items: [NFTItem] = [
        NFTItem(name: "April", rating: 1, price: 1.78, imageName: "CartImage0"),
        NFTItem(name: "Greena", rating: 3, price: 1.78, imageName: "CartImage1"),
        NFTItem(name: "Spring", rating: 5, price: 1.78, imageName: "CartImage2")
    ]
    
    var totalPrice: Double {
        return items.reduce(0) { $0 + $1.price }
    }
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage.sortImage, style: .plain, target: self, action: #selector(sortItems))
        button.tintColor = .ypBlack
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let totalCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypGreenUniversal

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("К оплате", for: .normal)
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupBottomView()
        setupTableView()
        setupConstraints()
        updateTotalPrice()
    }
    
    private func setupNavigationBar() {
            navigationItem.rightBarButtonItem = sortButton
        }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartCell.self, forCellReuseIdentifier: "CartCell")
        view.addSubview(tableView)
    }
    
    private func setupBottomView() {
        bottomView.addSubview(totalCountLabel)
        bottomView.addSubview(totalPriceLabel)
        bottomView.addSubview(payButton)
        view.addSubview(bottomView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.heightAnchor.constraint(equalToConstant: 76),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            totalCountLabel.topAnchor.constraint(equalTo: payButton.topAnchor),
            totalCountLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            
            totalPriceLabel.topAnchor.constraint(equalTo: totalCountLabel.bottomAnchor, constant: 2),
            totalPriceLabel.leadingAnchor.constraint(equalTo: totalCountLabel.leadingAnchor),
            
            payButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            payButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            payButton.widthAnchor.constraint(equalToConstant: 240),
            payButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func updateTotalPrice() {
        totalCountLabel.text = "\(items.count) NFT"
        totalPriceLabel.text = "\(totalPrice) ETH"
    }
    
    private func deleteItem(at indexPath: IndexPath) {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateTotalPrice()
        }
    
    @objc private func sortItems() {
            items.sort { $0.name < $1.name }
            tableView.reloadData()
        }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
            let item = items[indexPath.row]
            cell.configure(with: item) { [weak self] in
                self?.deleteItem(at: indexPath)
            }
            return cell
        }
        
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateTotalPrice()
        }
    }
}

struct NFTItem {
    var name: String
    var rating: Int
    var price: Double
    var imageName: String
}
