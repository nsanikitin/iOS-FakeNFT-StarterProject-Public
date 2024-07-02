//
//  CollectionsRequest.swift
//  FakeNFT
//
//  Created by Тася Галкина on 02.07.2024.
//

import Foundation

struct CollectionsRequest: NetworkRequest {
    var endpoint: URL?
    init() {
        guard let endpoint = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/collections") else { return }
        self.endpoint = endpoint
    }
}
