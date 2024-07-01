import Foundation

protocol StatisticsPresenterProtocol: AnyObject {
    
    func viewDidLoad()
    func loadUsersList()
    func getUsers() -> [UsersModel]
    func updateUsers()
    func sortUsersByRate()
    func sortUsersByName()
    func showError()
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    
    // MARK: - Properties
    
    private enum StatisticsState {
        case initial
        case loading
        case failed
        case data
    }
    
    private let  statisticsService = StatisticsService.shared
    
    weak var view: StatisticsViewController?
    private var users: [UsersModel] = []
    private var state = StatisticsState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Methods
    
    func viewDidLoad() {
        state = .loading
    }
    
    func loadUsersList() {
        statisticsService.fetchUsers { [weak self] (response: Result<[UsersModel], Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                users = body
                state = .data
            case .failure:
                state = .failed
            }
        }
    }
    
    func getUsers() -> [UsersModel] {
        users
    }
    
    func updateUsers() {
        view?.updateUsersTableView()
    }
    
    func sortUsersByRate() {
        users = users.sorted(by: { $0.nfts.count > $1.nfts.count })
        view?.updateUsersTableView()
    }
    
    func sortUsersByName() {
        users = users.sorted(by: { $0.name < $1.name})
        view?.updateUsersTableView()
    }
    
    func showError() {
        view?.showErrorAlert()
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("Can't move to initial state")
        case .loading:
            view?.showLoadingIndicator()
            loadUsersList()
        case .data:
            view?.hideLoadingIndicator()
            updateUsers()
        case .failed:
            view?.hideLoadingIndicator()
            showError()
        }
    }
}
