import Foundation

protocol StatisticsPresenterProtocol: AnyObject {
    
    var users: [UsersModel] { get set }
    
    func viewDidLoad()
    func loadUsersList()
    func updateUsers()
    func showError()
}

private enum statisticsState {
    case initial, loading, failed, data
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    
    // MARK: - Properties
    
    var users: [UsersModel] = []
    weak var view: StatisticsViewController?
    
    private var statisticsService = StatisticsService.shared
    private var state = statisticsState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Methods
    
    func viewDidLoad() {
        state = .loading
    }
    
    func loadUsersList() {
        statisticsService.fetchUsers()
    }
    
    func updateUsers() {
        state = .data
    }
    
    func showError() {
        state = .failed
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("Can't move to initial state")
        case .loading:
            view?.showLoadingIndicator()
            loadUsersList()
        case .data:
            users = statisticsService.users
            view?.hideLoadingIndicator()
        case .failed:
            view?.hideLoadingIndicator()
            view?.showErrorAlert()
        }
    }
}
