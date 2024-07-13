//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Anna on 01.07.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private init() {}
    
    private let urlSession = URLSession.shared
    private var urlSessionTask: URLSessionTask?
    private let tokenKey = TokenKeys.practicumMobile
    
    func fetchProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        guard let request = makeProfileGetRequest() else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        urlSessionTask = urlSession.objectTask(for: request) { (response: Result<ProfileModel, Error>) in
            completion(response)
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
        
        urlSessionTask = urlSession.objectTask(for: request) { (response: Result<ProfileModel, Error>) in
            completion(response)
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
    
    func updateLikes(_ likeRequest: LikeRequest, completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        guard let url = RequestConstants.profileURL else {
            assertionFailure("Invalid URL")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.put
        request.setValue(HTTPHeaders.applicationFormUrlEncoded, forHTTPHeaderField: HeaderFields.content)
        request.setValue(tokenKey, forHTTPHeaderField: HeaderFields.token)
        
        var dataString = ""
        if likeRequest.likes.isEmpty {
            dataString = "likes=null"
        } else {
            likeRequest.likes.forEach { likeId in
                if !dataString.isEmpty {
                    dataString += "&"
                }
                dataString += "likes=\(likeId)"
            }
        }

        request.httpBody = dataString.data(using: .utf8)
        
        urlSessionTask = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    guard let data = data else {
                        completion(.failure(NetworkError.noData))
                        return
                    }
                    
                    do {
                        let updatedProfile = try JSONDecoder().decode(ProfileModel.self, from: data)
                        completion(.success(updatedProfile))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    print("HTTP error: statusCode = \(httpResponse.statusCode)")
                    completion(.failure(NetworkError.invalidResponse))
                }
            }
        }
        urlSessionTask?.resume()
    }
}

extension ProfileService {
    func fetchNFTs(_ ids: [String], completion: @escaping (Result<[ProfileNFT], Error>) -> Void) {
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
                completion(.success(nftResponse))
            } catch {
                completion(.failure(error))
            }
        }
        urlSessionTask?.resume()
    }
    
    func fetchFavoriteNFTs(_ ids: [String], completion: @escaping (Result<[ProfileNFT], Error>) -> Void) {
        fetchNFTs(ids) { result in
            switch result {
            case .success(let allNfts):
                let favoriteNfts = allNfts.filter { ids.contains($0.id) }
                completion(.success(favoriteNfts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

