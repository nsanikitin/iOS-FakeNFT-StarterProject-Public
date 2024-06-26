//
//  PaymentOptionsViewController.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 23.06.2024.
//

import UIKit

final class PaymentOptionsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupUI()
    }
    
    @objc private func dismissController() {
            dismiss(animated: true, completion: nil)
        }
    
    private func setupUI() {
        
    }
    
    private func setupNavigationBar() {
            title = "Выберите способ оплаты"
            let backButton = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(dismissController)
            )
            backButton.tintColor = .ypBlack
            navigationItem.leftBarButtonItem = backButton
        }
}
