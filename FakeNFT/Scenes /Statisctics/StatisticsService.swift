import Foundation

final class StatisticsService {
    
    // MARK: - Properties
    
    static let shared = StatisticsService()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Methods
    
    func fetchUsers(completion: @escaping (Result<[UsersModel], Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = usersRequest()  else {
            assertionFailure("Invalid users request")
            return
        }
        
        URLSession.shared.objectTask(for: request) { [weak self] (response: Result<[UsersResult], Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                let result = body.map { self.convertToUserModel(userResult: $0) }
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
                print("[StatisticsService]: \(error.localizedDescription) \(request)")
            }
        }
    }
    
    private func usersRequest() -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/v1/users",
            httpMethod: "GET",
            baseURL: URL(string: RequestConstants.baseURL)
        )
        
        request?.setValue("application/json", forHTTPHeaderField: "Accept")
        request?.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
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
