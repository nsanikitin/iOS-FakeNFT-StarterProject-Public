//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Anna on 20.06.2024.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func didUpdateProfile(_ profile: ProfileModel)
}

protocol ProfileView: AnyObject {
    func displayProfile(_ profile: ProfileModel)
    func reloadTableView()
    func showLoading()
    func hideLoading()
    func showError(_ error: Error)
}

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var presenter: ProfilePresenter?
    private let sections = ["Мои NFT (112)", "Избранные NFT (11)", "О разработчике"]
    
    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = .ypBlack
        return label
    }()
    
    private let bioTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.caption2
        textView.textColor = .ypBlack
        textView.backgroundColor = .ypWhite
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let urlButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .caption1
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(.ypBlueUniversal, for: .normal)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(
        ProfileTableViewCell.self, 
        forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier
        )
        return tableView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ProfilePresenter(view: self)
        setupUI()
        setupNavigationItem()
        tableView.dataSource = self
        tableView.delegate = self
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    // MARK: - Public Functions
    
    @objc func editProfileTapped() {
        presenter?.editProfileTapped()
    }
    
    // MARK: - Private Functions
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        navigationController?.isNavigationBarHidden = false
        
        [avatarImage, nameLabel, bioTextView, urlButton, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),

            nameLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            bioTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bioTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bioTextView.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 10),

            urlButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 8),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: urlButton.bottomAnchor, constant: 40),
            tableView.heightAnchor.constraint(equalToConstant: 162)
        ])
    }
    
    private func setupNavigationItem() {
        let editButton = UIBarButtonItem(
            image: UIImage.squarePencilFigma,
            style: .plain,
            target: self,
            action: #selector(editProfileTapped)
        )
        editButton.tintColor = .ypBlack
        navigationItem.rightBarButtonItem = editButton
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - Extensions

extension ProfileViewController: ProfileView {
    
    func displayProfile(_ profile: ProfileModel) {
        if let urlString = profile.avatar, let url = URL(string: urlString) {
            avatarImage.loadImage(from: url, placeholder: UIImage(named: "avatarMockProfile"))
        } else {
            avatarImage.image = UIImage(named: "avatarMockProfile")
        }
        nameLabel.text = profile.name
        bioTextView.text = profile.description
        urlButton.setTitle(profile.website, for: .normal)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func showLoading() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoading() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func showError(_ error: Error) {
        let alertController = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.presenter?.viewDidLoad()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}


// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reuseIdentifier, for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        cell.updateTitle(text: sections[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let userNFTViewController = UserNFTViewController()
            navigationController?.pushViewController(userNFTViewController, animated: true)
        case 1:
            let favoriteNFTViewController = FavoriteNFTViewController()
            navigationController?.pushViewController(favoriteNFTViewController, animated: true)
        case 2:
            let developerInfoViewController = DeveloperInfoViewController()
            navigationController?.pushViewController(developerInfoViewController, animated: true)
        default:
            break
        }
    }
}
