import Kingfisher
import ProgressHUD
import UIKit

final class StatisticsUserViewController: UIViewController {
    
    // MARK: - Properties
    
    private var userNFTs: [String] = []
    private var userWebsite = ""
    
    private lazy var avatarImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private lazy var usernameLabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var userDescriptionTextView = {
        let textView = UITextView()
        textView.font = UIFont.caption2
        textView.textColor = .ypBlack
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 18)
        return textView
    }()
    
    private lazy var userWebsiteButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(NSLocalizedString("Statistics.goToUserWebsite", comment: "Перейти на сайт пользователя"),
                        for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = UIFont.caption1
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(goToUserWebsite), for: .touchUpInside)
        button.isEnabled = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypBlack.cgColor
        return button
    }()
    
    private lazy var nftCollectionButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(goToNFTCollection), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    private lazy var nftCollectionLabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = .ypBlack
        label.font = UIFont.bodyBold
        return label
    }()
    
    private lazy var nftCollectionImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.tintColor = .ypBlack
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupUI()
    }
    
    // MARK: - Methods
    
    func configure(for user: UsersModel) {
        avatarImageView.kf.setImage(with: URL(string: user.avatar), placeholder: UIImage(named: "person"))
        usernameLabel.text = user.name
        userDescriptionTextView.text = user.description
        nftCollectionLabel.text = "\(NSLocalizedString("Statistics.nftCollection", comment: "Колекция NFT")) (\(user.nfts.count))"
        userNFTs = user.nfts
        userWebsite = user.website
    }
    
    private func goToViewController(viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        present(navigationController, animated: true)
    }
    
    private func showAlertNFTsAreEmpty() {
        let alert = UIAlertController(
            title: NSLocalizedString("Error.noNft", comment: "У пользователя нет NFT"),
            message: nil,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: NSLocalizedString("Error.ok" , comment: "Ок"),
                                   style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    private func setupUI() {
        setupNavBar()
        setupConstraints()
    }
    
    // MARK: - View Configuration
    
    private func setupNavBar() {
        let backButton = UIBarButtonItem(
            image: UIImage.backwardImage,
            style: .plain,
            target: self,
            action: #selector(backToStaticsVC)
        )
        backButton.tintColor = .ypBlack
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupConstraints() {
        [avatarImageView, usernameLabel, userDescriptionTextView, userWebsiteButton, nftCollectionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [nftCollectionLabel, nftCollectionImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            nftCollectionButton.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            usernameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            userDescriptionTextView.heightAnchor.constraint(equalToConstant: 72),
            userDescriptionTextView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            userDescriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            userDescriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            userWebsiteButton.heightAnchor.constraint(equalToConstant: 40),
            userWebsiteButton.topAnchor.constraint(equalTo: userDescriptionTextView.bottomAnchor, constant: 28),
            userWebsiteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userWebsiteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            nftCollectionButton.heightAnchor.constraint(equalToConstant: 54),
            nftCollectionButton.topAnchor.constraint(equalTo: userWebsiteButton.bottomAnchor, constant: 40),
            nftCollectionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nftCollectionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            nftCollectionImageView.centerYAnchor.constraint(equalTo: nftCollectionButton.centerYAnchor),
            nftCollectionImageView.trailingAnchor.constraint(equalTo: nftCollectionButton.trailingAnchor, constant: -16),
            
            nftCollectionLabel.centerYAnchor.constraint(equalTo: nftCollectionButton.centerYAnchor),
            nftCollectionLabel.leadingAnchor.constraint(equalTo: nftCollectionButton.leadingAnchor, constant: 16)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func backToStaticsVC() {
        dismiss(animated: true)
    }
    
    @objc
    private func goToNFTCollection() {
        if userNFTs.isEmpty {
            showAlertNFTsAreEmpty()
            return
        }
        
        let viewController = StatisticsUserNFTCollectionViewController(userNFTs: userNFTs)
        goToViewController(viewController: viewController)
    }
    
    @objc
    private func goToUserWebsite() {
        let viewController = StatisticsUserWebViewController()
        goToViewController(viewController: viewController)
        viewController.loadUserWebsite(website: userWebsite)
    }
}
