//
//  DeleteConfirmationViewController.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 23.06.2024.
//

import UIKit

final class DeleteConfirmationViewController: UIViewController {
    
    var confirmHandler: (() -> Void)?
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        // imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы уверены, что хотите удалить объект из корзины?"
        label.font = .caption2
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.ypRedUniversal, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(confirmDelete), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вернуться", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.addSubview(blurEffectView)
        view.addSubview(containerView)
        containerView.addSubview(itemImageView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(deleteButton)
        containerView.addSubview(cancelButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 262),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
            itemImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            itemImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 108),
            itemImageView.heightAnchor.constraint(equalToConstant: 108),
            
            messageLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 41),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -41),
            
            deleteButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -4),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.topAnchor.constraint(equalTo: deleteButton.topAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 4),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func confirmDelete() {
        confirmHandler?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    func configure(with image: UIImage?) {
        itemImageView.image = .cartDelete
    }
}
