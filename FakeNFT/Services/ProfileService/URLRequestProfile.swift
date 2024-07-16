//
//  URLRequestProfile.swift
//  FakeNFT
//
//  Created by Anna on 01.07.2024.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL?
    ) -> URLRequest? {
        guard
            let baseURL = baseURL,
            let url = URL(string: path, relativeTo: baseURL)
        else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
