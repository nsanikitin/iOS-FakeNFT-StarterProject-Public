import UIKit

final class StatisticsUserNFTCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var nftCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 7
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            StatisticsCollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .viewBackgroundColor
        setupUI()
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        setupNavBar()
        setupConstraints()
    }
    
    // MARK: - View Configuration
    
    private func setupNavBar() {
        title = "Коллекция NFT"
        
        let backButton = UIBarButtonItem(
            image: UIImage.backwardImage,
            style: .plain,
            target: self,
            action: #selector(backToStatisticsUserVC)
        )
        backButton.tintColor = .ypBlackUniversal
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
        // TODO: - Загрузить количество NFT
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: - Настройка данных в ячейке коллекции
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as? StatisticsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure()
        
        return cell
    }
}

// MARK: - CollectionView DelegateFlowLayout

extension StatisticsUserNFTCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width / 3,
            height: 192
        )
    }
}
