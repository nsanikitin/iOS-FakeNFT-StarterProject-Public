//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 20.06.2024.
//

import Foundation

class CartPresenter {
    weak var view: CartView?
    private var items: [NFTModel] = []

    init(view: CartView) {
        self.view = view
        loadItems()
    }

    var totalPrice: Float {
        return items.reduce(0) { $0 + $1.price }
    }

    func loadItems() {
        items = [
            NFTModel(createdAt: Date(), name: "April", images: ["CartImage0"], rating: 1, description: nil, price: 1.78, author: "Author1", id: "1"),
            NFTModel(createdAt: Date(), name: "Greena", images: ["CartImage1"], rating: 3, description: nil, price: 1.78, author: "Author2", id: "2"),
            NFTModel(createdAt: Date(), name: "Spring", images: ["CartImage2"], rating: 5, description: nil, price: 1.78, author: "Author3", id: "3")
        ]
        view?.updateTotalPrice(totalCount: items.count, totalPrice: totalPrice)
        view?.reloadData()
    }

    func getItem(at index: Int) -> NFTModel {
        return items[index]
    }

    func numberOfItems() -> Int {
        return items.count
    }

    func deleteItem(at index: Int) {
        items.remove(at: index)
        view?.updateTotalPrice(totalCount: items.count, totalPrice: totalPrice)
        view?.reloadData()
    }

    func sortItems() {
        items.sort { $0.name < $1.name }
        view?.reloadData()
    }
}
