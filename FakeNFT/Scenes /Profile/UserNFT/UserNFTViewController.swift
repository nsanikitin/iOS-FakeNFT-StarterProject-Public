//
//  UserNFTViewController.swift
//  FakeNFT
//
//  Created by Anna on 21.06.2024.
//

import UIKit

final class UserNFTViewController: UIViewController {
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationItem()
    }
    
    // MARK: - Private Functions
    
    @objc func sortButtonTapped() {
        // TODO: Реализация функции сортировки
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
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
