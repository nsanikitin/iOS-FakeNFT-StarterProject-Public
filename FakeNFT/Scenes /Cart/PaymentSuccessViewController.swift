//
//  PaymentSuccessViewController.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 03.07.2024.
//

import UIKit

final class PaymentSuccessViewController: UIViewController {
    
    private let successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "successPay")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.text = "Успех! Оплата прошла, поздравляем с покупкой!"
        label.font = .headline3
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вернуться в каталог", for: .normal)
        button.backgroundColor = UIColor(named: "ypBlack")
        button.setTitleColor(UIColor(named: "ypWhite"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(returnToCatalog), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ypWhite")
        navigationItem.hidesBackButton = true
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.addSubview(successImageView)
        view.addSubview(successLabel)
        view.addSubview(returnButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            successImageView.widthAnchor.constraint(equalToConstant: 278),
            successImageView.heightAnchor.constraint(equalToConstant: 278),
            
            successLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 20),
            successLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            successLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            returnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            returnButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func returnToCatalog() {
        NotificationCenter.default.post(name: NSNotification.Name("ReturnToCatalog"), object: nil)
        dismiss(animated: true, completion: nil)
    }
}
