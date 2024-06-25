import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: StatisticPresenterProtocol?
    
    private lazy var usersTableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.rowHeight = 88
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .viewBackgroundColor
        setupUI()
    }
    
    // MARK: - Methods
    
    // MARK: - View Configuration
    
    private func setupUI() {
        setupNavBar()
        setupUsersTableView()
    }
    
    private func setupNavBar() {
        let sortButton = UIBarButtonItem(
            image: UIImage.sortImage,
            style: .plain,
            target: self,
            action: #selector(sortButtonDidTap)
        )
        sortButton.tintColor = .ypBlack
        self.navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupUsersTableView() {
        usersTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usersTableView)
        
        NSLayoutConstraint.activate([
            usersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            usersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            usersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            usersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func sortButtonDidTap() {
        // TODO: - Показ алерта со способом сортировки
    }
}

// MARK: - TableView DataSource

extension StatisticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StatisticTableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        return cell
    }
}

// MARK: - TableView Delegate

extension StatisticsViewController: UITableViewDelegate {
    
    
}



