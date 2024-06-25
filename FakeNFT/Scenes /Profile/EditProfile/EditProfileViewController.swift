//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Anna on 23.06.2024.
//

import UIKit

final class EditProfileViewController: UIViewController {

    // MARK: - Private Properties
    
    private var likes: [String]?
    private var profile: ProfileModel?
    weak var delegate: ProfileViewControllerDelegate?

    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private let shadowView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 35
        view.backgroundColor = .ypBlack?.withAlphaComponent(0.4)
        return view
    }()
    
    private let changeAvatarButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сменить \n фото", for: .normal)
        button.titleLabel?.font = UIFont.caption3
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(changeAvatarTapped), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = .ypBlack
        label.text = "Имя"
        return label
    }()
    
    private let nameTextField: PaddedTextField = {
        let textField = PaddedTextField(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .ypLightGrey
        textField.textColor = .ypBlack
        textField.font = UIFont.bodyRegular
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = UIFont.headline3
        label.textColor = .ypBlack
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .ypLightGrey
        textView.font = UIFont.bodyRegular
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 26)
        return textView
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.text = "Сайт"
        label.font = UIFont.headline3
        label.textColor = .ypBlack
        return label
    }()
    
    private let urlTextField: PaddedTextField = {
        let textField = PaddedTextField(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .ypLightGrey
        textField.font = UIFont.bodyRegular
        return textField
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.crossImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(clearText(_:)), for: .touchUpInside)
        return button
    }()
    
    private let descriptionClearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.crossImage, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(clearTextView(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    func configure(profile: ProfileModel) {
        self.profile = profile
        avatarImage.image = UIImage(named: profile.avatar ?? "avatarMockProfile")
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description
        urlTextField.text = profile.website
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupUI()
        
        nameTextField.delegate = self
        urlTextField.delegate = self
        descriptionTextView.delegate = self
        
        setupTextField(nameTextField)
        setupTextField(urlTextField)
        setupDescriptionClearButton()
    }
    
    // MARK: - Private Functions

    @objc func closeButtonTapped() {
        guard let profile = profile else { return }
        
        let updatedProfile = ProfileModel(
            name: nameTextField.text ?? profile.name,
            avatar: profile.avatar,
            description: descriptionTextView.text,
            website: urlTextField.text,
            nfts: profile.nfts,
            likes: profile.likes,
            id: profile.id
        )
        
        delegate?.didUpdateProfile(updatedProfile)
        dismiss(animated: true)
    }
    
    @objc func changeAvatarTapped() {
        // TODO: Логика измнения ссылки на аватар
        
        let alert = UIAlertController(
            title: "Введите URL",
            message: "Изменить ссылку на изображение",
            preferredStyle: .alert)
        
        alert.addTextField { textField in
                textField.placeholder = "URL изображения"
            }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in }
        let confirmAction = UIAlertAction(title: "Подтвердить", style: .default) { [weak self] _ in
            guard 
                let textField = alert.textFields?.first,
                let newURL = textField.text, !newURL.isEmpty else { return }
            // Обновление ссылки на аватар в модели и UI
            self?.updateAvatarURL(newURL)
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func clearText(_ sender: UIButton) {
        if let textField = sender.superview as? UITextField {
            textField.text = ""
        }
    }
    
    @objc private func clearTextView(_ sender: UIButton) {
        descriptionTextView.text = ""
    }
    
    private func updateAvatarURL(_ newURL: String) {
        // TODO: логика изменения ссылки для изображения
    }
    
    private func setupNavigationItem() {
        navigationController?.isNavigationBarHidden = false
        
        let closeButton = UIBarButtonItem(
            image: UIImage.closeImage,
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
        closeButton.tintColor = .ypBlack
        navigationItem.rightBarButtonItem = closeButton
        
        view.backgroundColor = .ypWhite
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        [avatarImage, shadowView, changeAvatarButton, nameLabel, nameTextField, descriptionLabel, descriptionTextView, urlLabel, urlTextField].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            avatarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            
            shadowView.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: avatarImage.trailingAnchor),
            shadowView.topAnchor.constraint(equalTo: avatarImage.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: avatarImage.bottomAnchor),
            
            changeAvatarButton.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            changeAvatarButton.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            changeAvatarButton.topAnchor.constraint(equalTo: shadowView.topAnchor),
            changeAvatarButton.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 132),
            
            urlLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            urlLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            urlTextField.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 8),
            urlTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            urlTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            urlTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

// MARK: - Extensions

extension EditProfileViewController {
    private func setupTextField(_ textField: PaddedTextField) {
        textField.rightView = clearButton
        textField.rightViewMode = .whileEditing
    }
    
    private func setupDescriptionClearButton() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        containerView.addSubview(descriptionClearButton)

        view.addSubview(containerView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: descriptionTextView.topAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 30),
            containerView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

extension EditProfileViewController: UITextFieldDelegate, UITextViewDelegate {
    
    // MARK: - UITextFieldDelegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let rightView = textField.rightView as? UIButton {
            rightView.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let rightView = textField.rightView as? UIButton {
            rightView.isHidden = true
        }
    }
    
    // MARK: - UITextViewDelegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == descriptionTextView {
            descriptionClearButton.isHidden = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == descriptionTextView {
            descriptionClearButton.isHidden = true
        }
    }
}


