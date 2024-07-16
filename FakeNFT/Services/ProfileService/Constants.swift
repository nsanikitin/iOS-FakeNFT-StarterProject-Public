// Constants.swift

import Foundation

enum RequestConstants {
    static let baseURL = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
    
    enum Paths {
        static let profile = "/api/v1/profile/1"
    }
    
    static var profileURL: URL? {
        return URL(string: baseURL + Paths.profile)
    }
}

enum HTTPHeaders {
    static let applicationJson = "application/json"
    static let applicationFormUrlEncoded = "application/x-www-form-urlencoded"
}

enum HTTPMethods {
    static let get = "GET"
    static let put = "PUT"
}

enum TokenKeys {
    static let practicumMobile = "61d3c8db-a147-4ae1-87cc-74329c18ff32"
}

enum HeaderFields {
    static let accept = "Accept"
    static let content = "Content-Type"
    static let token = "X-Practicum-Mobile-Token"
}
