import UIKit
import ProgressHUD

final class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
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
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .viewBackgroundColor
        setupUI()
        
        presenter.view = self
        presenter.viewDidLoad()
        addObserver()
    }
    
    // MARK: - Methods
    
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
    
    private func addObserver() {
        statisticsServiceObserver = NotificationCenter.default
            .addObserver(
                forName: StatisticsService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                guard let self = self else { return }
                self.presenter.updateUsers()
                self.usersTableView.reloadData()
            }
    }
    
    private func setupUI() {
        setupNavBar()
        setupUsersTableView()
    }
    
    // MARK: - View Configuration
    
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
        return presenter.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StatisticsTableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let user = presenter.users[indexPath.row]
        cell.configure(numberOfCell: indexPath.row + 1, for: user)
        
        return cell
    }
}

// MARK: - TableView Delegate

extension StatisticsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - Переход на экран профиля пользователя
    }
}
