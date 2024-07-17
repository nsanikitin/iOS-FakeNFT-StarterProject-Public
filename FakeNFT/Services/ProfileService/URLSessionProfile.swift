//
//  URLSessionProfile.swift
//  FakeNFT
//
//  Created by Anna on 01.07.2024.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if
                let data = data,
                let response = response, 
                let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletion(.success(result))
                    } catch {
                        fulfillCompletion(.failure(NetworkErrorProfile.decodingError(error)))
                    }
                } else {
                    fulfillCompletion(.failure(NetworkErrorProfile.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkErrorProfile.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkErrorProfile.urlSessionError))
            }
        }
        task.resume()
        return task
    }
}
