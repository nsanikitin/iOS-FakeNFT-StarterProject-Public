////
////  NftListServiceImpl.swift
////  FakeNFT
////
////  Created by Рамиль Аглямов on 23.06.2024.
////
//
//import Foundation
//
//final class NftListServiceImpl: NftListService {
//    
//    private let networkClient: NetworkClient
//
//    init(networkClient: NetworkClient) {
//        self.networkClient = networkClient
//    }
//
//    func loadNftList(completion: @escaping NftListCompletion) {
//        let request = NFTListRequest()
//        networkClient.send(request: request, type: [NFTModel].self) { result in
//            switch result {
//            case .success(let nftList):
//                completion(.success(nftList))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//}
