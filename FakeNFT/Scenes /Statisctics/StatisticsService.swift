import Foundation

final class StatisticsService {
    
    // MARK: - Properties
    
    static let shared = StatisticsService()
    private let tokenKey = TokenKeys.practicumMobile
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Users fetching
    
    func fetchUsers(completion: @escaping (Result<[UsersModel], Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = usersRequest()  else {
            assertionFailure("Invalid users request")
            return
        }
        
        URLSession.shared.objectTaskStatistic(for: request) { [weak self] (response: Result<[UsersResult], Error>) in
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
        request?.setValue(tokenKey, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
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
    
    // MARK: - NFTs fetching
    
    func fetchNFTs(completion: @escaping (Result<[NFTModel], Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = nftRequest()  else {
            assertionFailure("Invalid users request")
            return
        }
        
        URLSession.shared.objectTaskStatistic(for: request) { [weak self] (response: Result<[NFTResult], Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                let result = body.map { self.convertToNFTModel(nftResult: $0) }
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
                print("[StatisticsService]: \(error.localizedDescription) \(request)")
            }
        }
    }
    
    private func nftRequest() -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/v1/nft",
            httpMethod: "GET",
            baseURL: URL(string: RequestConstants.baseURL)
        )
        
        request?.setValue("application/json", forHTTPHeaderField: "Accept")
        request?.setValue(tokenKey, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
    
    private func convertToNFTModel(nftResult: NFTResult) -> NFTModel {
        let nftModel = NFTModel(
            createdAt: nftResult.createdAt,
            name: nftResult.name,
            images: nftResult.images,
            rating: nftResult.rating,
            description: nftResult.description,
            price: nftResult.price,
            author: nftResult.author,
            id: nftResult.id
        )
        
        return nftModel
    }
 }
