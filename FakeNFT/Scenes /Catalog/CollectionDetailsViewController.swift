//
//  CollectionDetailsViewController.swift
//  FakeNFT
//
//  Created by Тася Галкина on 02.07.2024.
//

import Foundation
import UIKit

final class CollectionDetailsViewController: UIViewController {
    
    let backButton = UIButton()
    
    private func configureBackButton() {
        view.addSubview(backButton)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        configureBackButton()
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
