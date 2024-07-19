//
//  NetworkError.swift
//  FakeNFT
//
//  Created by Anna on 01.07.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case decodingError(Error)
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidResponse
    case noData
}
