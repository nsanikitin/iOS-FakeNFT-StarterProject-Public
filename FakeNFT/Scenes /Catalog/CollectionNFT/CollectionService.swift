//
//  CollectionService.swift
//  FakeNFT
//
//  Created by Тася Галкина on 12.07.2024.
//

import Foundation

final class CollectionService {
    
    static let shared = CollectionService()
    private init() {}
    
    var nftsIDs: [String] = []
    var visibleNFT: [Nft] = []
    var nft: Nft?
    
    func changeLike(newLikes: [String], profile: ProfileModelNFT, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let nft = self.nft else { return }
        let likesString = newLikes.joined(separator: ",")
        let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/profile/1")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("61d3c8db-a147-4ae1-87cc-74329c18ff32", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        var parameters: [String: String] = [: ]
        
        if profile.likes.count == 1 && profile.likes.contains(nft.id) {
            parameters = ["likes": "null"]
        } else {
            parameters = ["likes": likesString]
        }
        
        let bodyString = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
        task.resume()
    }
    
    func changeCart(newCart: [String], cart: CartModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let cartString = newCart.joined(separator: ",")
        let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/1")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("61d3c8db-a147-4ae1-87cc-74329c18ff32", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let parameters = ["nfts": cartString]
        let bodyString = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
        task.resume()
    }
    
    func getProfile(completion: @escaping (Result<ProfileModelNFT, Error>) -> Void) {
        let headers = [
            "Accept": "application/json",
            "X-Practicum-Mobile-Token": "61d3c8db-a147-4ae1-87cc-74329c18ff32"
        ]
        
        let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/profile/1")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let object = try JSONDecoder().decode(ProfileModelNFT.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getCart(completion: @escaping (Result<CartModel, Error>) -> Void) {
        let headers = [
            "Accept": "application/json",
            "X-Practicum-Mobile-Token": "61d3c8db-a147-4ae1-87cc-74329c18ff32"
        ]
        
        let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/1")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let object = try JSONDecoder().decode(CartModel.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
