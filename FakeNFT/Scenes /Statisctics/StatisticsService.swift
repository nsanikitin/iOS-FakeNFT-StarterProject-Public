import Foundation

final class StatisticsService {
    
    // MARK: - Properties
    
    static let shared = StatisticsService()
    static let didChangeNotification = Notification.Name(rawValue: "StatisticServiceDidChange")
    
    private let token = RequestConstants.token
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private (set) var users: [UsersModel] = []
    
    // MARK: - Methods
    
    func fetchUsers() {
        assert(Thread.isMainThread)
        
        if task != nil {
            task?.cancel()
        }
        
        guard let request = usersRequest()  else {
            assertionFailure("Invalid users request")
            return
        }
        
        _ = urlSession.objectTask(for: request) { [weak self] (response: Result<[UsersResult], Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                DispatchQueue.main.async {
                    body.forEach { result in
                        self.users.append(self.convertToUserModel(userResult: result))
                    }
                    NotificationCenter.default
                        .post(name: StatisticsService.didChangeNotification,
                              object: self)
                }
            case .failure(let error):
                StatisticsPresenter().showError()
                print("[StatisticsService]: \(error.localizedDescription) \(request)")
            }
            
            self.task = nil
        }
    }
    
    private func usersRequest() -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/v1/users",
            httpMethod: "GET",
            baseURL: URL(string: RequestConstants.baseURL)
        )
        
        request?.setValue("application/json", forHTTPHeaderField: "Accept")
        request?.setValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
    
    private func convertToUserModel(userResult: UsersResult) -> UsersModel {
        let userModel = UsersModel(
            name: userResult.name,
            avatar: userResult.avatar,
            description: userResult.description,
            website: userResult.website,
            nfts: userResult.nfts,
            rating: userResult.rating,
            id: userResult.id
        )
        
        return userModel
    }
 }
