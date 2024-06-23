//
//  NetworkClientCart.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 23.06.2024.
//

import Foundation

class NetworkClientCart {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send<T: Decodable>(request: URLRequest, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
        task.resume()
    }
}

