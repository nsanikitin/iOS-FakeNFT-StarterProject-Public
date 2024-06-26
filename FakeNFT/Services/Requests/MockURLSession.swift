//
//  MockURLSession.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 23.06.2024.
//

import Foundation

class MockURLSession: URLSession {
    var nextData: Data?
    var nextError: Error?

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask {
            completionHandler(self.nextData, nil, self.nextError)
        }
    }

    class MockURLSessionDataTask: URLSessionDataTask {
        private let closure: () -> Void

        init(closure: @escaping () -> Void) {
            self.closure = closure
        }

        override func resume() {
            closure()
        }
    }
}
