import UIKit
import ProgressHUD

final class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let refreshControl = UIRefreshControl()
    
    private var statisticsServiceObserver: NSObjectProtocol?
    
    private lazy var presenter = StatisticsPresenter()
    private lazy var usersTableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.rowHeight = 88
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .viewBackgroundColor
        setupUI()
        
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    // MARK: - Methods
    
    func updateUsersTableView() {
        usersTableView.reloadData()
    }
    
    func showLoadingIndicator() {
        ProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        ProgressHUD.dismiss()
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(
            title: "Не удалось получить данные",
            message: nil,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        let action = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.viewDidLoad()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(action)
        alert.preferredAction = action
        
        present(alert, animated: true)
    }
    
    private func setupUI() {
        setupNavBar()
        setupUsersTableView()
    }
    
    private func showSortAlert() {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let sortByNameAction = UIAlertAction(title: "По имени", style: .default) { [weak self] _ in
            self?.sortByName()
            
        }
        let sortByRateAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.sortByRate()
        }
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(sortByNameAction)
        alert.addAction(sortByRateAction)
        alert.addAction(closeAction)
        
        present(alert, animated: true)
    }
    
    private func sortByRate() {
        presenter.sortUsersByRate()
    }
    
    private func sortByName() {
        presenter.sortUsersByName()
    }
    
    // MARK: - View Configuration
    
    private func setupNavBar() {
        let sortButton = UIBarButtonItem(
            image: UIImage.sortImage,
            style: .plain,
            target: self,
            action: #selector(sortButtonDidTap)
        )
        sortButton.tintColor = .ypBlackUniversal
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
        showSortAlert()
    }
    
    @objc
    private func refreshTableView() {
        presenter.viewDidLoad()
        refreshControl.endRefreshing()
    }
}

// MARK: - TableView DataSource

extension StatisticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getUsers().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StatisticsTableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let user = presenter.getUsers()[indexPath.row]
        cell.configure(numberOfCell: indexPath.row + 1, for: user)
        
        return cell
    }
}

// MARK: - TableView Delegate

extension StatisticsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StatisticsUserViewController()
        let user = presenter.getUsers()[indexPath.row]
        vc.configure(for: user)
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        present(navigationController, animated: true)
    }
}
