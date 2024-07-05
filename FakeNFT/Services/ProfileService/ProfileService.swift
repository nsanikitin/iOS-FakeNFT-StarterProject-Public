//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Anna on 01.07.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private (set) var profile: ProfileModel?
    private (set) var userNfts: [ProfileNFT]?
    
    private init() {}
    
    private let urlSession = URLSession.shared
    private var urlSessionTask: URLSessionTask?
    private var token: String?
    private let tokenKey = TokenKeys.practicumMobile
    
    func fetchProfile(completion: @escaping (Result<ProfileModel, Error>)-> Void) {
        guard let request = makeProfileGetRequest() else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        urlSessionTask = urlSession.objectTask(for: request) { (response: Result<ProfileModel, Error>) in
            switch response {
            case .success(let profileResult):
                completion(.success(profileResult))
                self.fetchNFTs(profileResult.nfts, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func makeProfileGetRequest() -> URLRequest? {
        guard let url = RequestConstants.profileURL else {
            fatalError("Failed to create URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.get
        request.setValue(HTTPHeaders.applicationJson, forHTTPHeaderField: HeaderFields.accept)
        request.setValue(tokenKey, forHTTPHeaderField: HeaderFields.token)
        return request
    }
    
    func updateProfile(with profileUpdate: ProfileUpdate, completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        guard let request = makeProfilePutRequest(profile: profileUpdate) else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        UIBlockingProgressHUD.show()
        urlSessionTask = urlSession.objectTask(for: request) { (response: Result<ProfileModel, Error>) in
            UIBlockingProgressHUD.dismiss()
            switch response {
            case .success(let profileResult):
                self.profile = profileResult
                completion(.success(profileResult))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func makeProfilePutRequest(profile: ProfileUpdate) -> URLRequest? {
        guard let url = RequestConstants.profileURL else {
            fatalError("Failed to create URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.put
        request.setValue(HTTPHeaders.applicationFormUrlEncoded, forHTTPHeaderField: HeaderFields.content)
        request.setValue(tokenKey, forHTTPHeaderField: HeaderFields.token)
        
        var dataString = "name=\(profile.name)&description=\(profile.description)&website=\(profile.website)"
        profile.likes.forEach { likeId in
            dataString += "&likes=\(likeId)"
        }
        request.httpBody = dataString.data(using: .utf8)
        return request
    }
}

extension ProfileService {
    private func fetchNFTs(_ ids: [String], completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        let idsString = ids.joined(separator: ",")
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/nft?ids=\(idsString)") else {
            assertionFailure("Invalid URL")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.get
        request.setValue(HTTPHeaders.applicationJson, forHTTPHeaderField: HeaderFields.accept)
        request.setValue(tokenKey, forHTTPHeaderField: HeaderFields.token)
        
        urlSessionTask = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                let nftResponse = try JSONDecoder().decode([ProfileNFT].self, from: data)
                self.userNfts = nftResponse
                if let profile = self.profile {
                    completion(.success(profile))
                }
            } catch {
                completion(.failure(error))
            }
        }
        urlSessionTask?.resume()
    }
}

