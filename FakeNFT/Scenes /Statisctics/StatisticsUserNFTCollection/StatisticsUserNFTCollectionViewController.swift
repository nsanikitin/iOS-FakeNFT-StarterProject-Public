import ProgressHUD
import UIKit

final class StatisticsUserNFTCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private var userNFTs: [String]
    
    private lazy var presenter = StatisticsUserNFTCollectionPresenter()
    private lazy var nftCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            StatisticsCollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        
        return collectionView
    }()
    
    // MARK: - Init
    
    init(userNFTs: [String]) {
        self.userNFTs = userNFTs
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        setupUI()
        
        presenter.view = self
        presenter.viewDidLoad(with: userNFTs)
    }
    
    // MARK: - Methods
    
    func updateNFTCollectionView() {
        nftCollectionView.reloadData()
    }
    
    func showLoadingIndicator() {
        ProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        ProgressHUD.dismiss()
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("Error.data", comment: "Не удалось получить данные"),
            message: nil,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Error.cancel", comment: "Отмена"),
                                         style: .default)
        let action = UIAlertAction(title: NSLocalizedString("Error.repeat", comment: "Повторить"),
                                   style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.viewDidLoad(with: userNFTs)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(action)
        alert.preferredAction = action
        
        present(alert, animated: true)
    }
    
    private func setupUI() {
        setupNavBar()
        setupConstraints()
    }
    
    // MARK: - View Configuration
    
    private func setupNavBar() {
        title = NSLocalizedString("Statistics.nftCollection" , comment: "Коллекция NFT")
        
        let backButton = UIBarButtonItem(
            image: UIImage.backwardImage,
            style: .plain,
            target: self,
            action: #selector(backToStatisticsUserVC)
        )
        backButton.tintColor = .ypBlack
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupConstraints() {
        nftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nftCollectionView)
        
        NSLayoutConstraint.activate([
            nftCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func backToStatisticsUserVC() {
        dismiss(animated: true)
    }
}

// MARK: - CollectionView DataSource Extension

extension StatisticsUserNFTCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getUserNFTs().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as? StatisticsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let nft = presenter.getUserNFTs()[indexPath.row]
        cell.configure(for: nft)
        
        return cell
    }
}

// MARK: - CollectionView DelegateFlowLayout

extension StatisticsUserNFTCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: 108,
            height: 192
        )
    }
}
