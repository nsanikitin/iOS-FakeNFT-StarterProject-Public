//
//  NFTServiceCart.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 23.06.2024.
//
import UIKit

final class ServiceCart {
    private let networkClient: NetworkClientCart
    private let baseURL: String
    private let token: String
    
    init(networkClient: NetworkClientCart, baseURL: String = ConfigCart.URNFTCart, token: String = ConfigCart.tokenCart) {
        self.networkClient = networkClient
        self.baseURL = baseURL
        self.token = token
    }
    
    private func sendRequest<T: Decodable>(endpoint: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        networkClient.send(request: request, type: type, completion: completion)
    }
    
    func loadNFTs(completion: @escaping (Result<[NFTModel], Error>) -> Void) {
        sendRequest(endpoint: "nft", type: [NFTModel].self) { result in
            switch result {
            case .success(let nftList):
                let limitedNftList = Array(nftList.prefix(5))
                completion(.success(limitedNftList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadCurrencies(completion: @escaping (Result<[CurrencyModel], Error>) -> Void) {
        sendRequest(endpoint: "currencies", type: [CurrencyModel].self, completion: completion)
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        networkClient.loadImage(from: url) { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func pay(currencyId: String, completion: @escaping (Result<PaymentResponse, Error>) -> Void) {
        let endpoint = "orders/1/payment/\(currencyId)"
        sendRequest(endpoint: endpoint, type: PaymentResponse.self, completion: completion)
    }
}
