//
//  CartView.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 20.06.2024.
//

import Foundation

protocol CartView: AnyObject {
    func updateTotalPrice(totalCount: Int, totalPrice: Float)
    func reloadData()
    func showLoading()
    func hideLoading()
}
