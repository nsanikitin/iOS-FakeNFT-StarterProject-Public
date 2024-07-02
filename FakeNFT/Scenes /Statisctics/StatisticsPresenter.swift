import Foundation

protocol StatisticsPresenterProtocol: AnyObject {
    
    func viewDidLoad()
    func loadUsersList()
    func getUsers() -> [UsersModel]
    func updateUsers()
    func sortedUsers(_ type: UsersSortedType)
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
    
    private let statisticsService = StatisticsService.shared
    private let statisticsUserDefaults = StatisticsUserDefaults()
    
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
    
    func sortedUsers(_ type: UsersSortedType) {
        view?.hideLoadingIndicator()
        statisticsUserDefaults.sortingWay = type.rawValue
        switch type {
        case .byRate:
            users = users.sorted { $0.nfts.count > $1.nfts.count }
        case .byName:
            users = users.sorted { $0.name < $1.name }
        }
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
            switch statisticsUserDefaults.sortingWay {
            case "byRate":
                users = users.sorted { $0.nfts.count > $1.nfts.count }
            case "byName":
                users = users.sorted { $0.name < $1.name }
            default:
                break
            }
            view?.updateUsersTableView()
        case .failed:
            view?.hideLoadingIndicator()
            showError()
        }
    }
}
