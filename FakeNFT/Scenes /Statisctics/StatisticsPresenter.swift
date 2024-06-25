import Foundation

protocol StatisticsPresenterProtocol: AnyObject {
    
    var users: [ProfileModel] { get set }
    
    func getUsersList()
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    
    // MARK: - Properties

    var users: [ProfileModel] = []
    
    // MARK: - Methods
    
    func getUsersList() {
        
    }
}
