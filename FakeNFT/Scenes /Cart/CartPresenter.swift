import Foundation

final class CartPresenter {
    
    enum SortOption {
        case price
        case rating
        case name
    }
    
    weak var view: CartView?
    private var items: [NFTModel] = []
    private let nftServiceCart: ServiceCart
    
    init(view: CartView, nftServiceCart: ServiceCart) {
        self.view = view
        self.nftServiceCart = nftServiceCart
        loadItems()
    }
    
    var totalPrice: Float {
        let total = items.reduce(0) { $0 + $1.price }
        return total.rounded(toPlaces: 2)
    }
    
    private func loadItems() {
        view?.showLoading()
        nftServiceCart.loadNFTs { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()  
                switch result {
                case .success(let nftList):
                    self?.items = Array(nftList.prefix(3))
                    self?.view?.updateTotalPrice(totalCount: self?.items.count ?? 0, totalPrice: self?.totalPrice ?? 0)
                    self?.view?.reloadData()
                    self?.view?.setPayButtonEnabled(true)
                case .failure(let error):
                    print("Ошибка загрузки списка NFT: \(error.localizedDescription)")
                }
            }
        }
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
    
    func sortItems(by option: SortOption) {
        switch option {
        case .price:
            items.sort { $0.price < $1.price }
        case .rating:
            items.sort { $0.rating > $1.rating }
        case .name:
            items.sort { $0.name < $1.name }
        }
        view?.reloadData()
    }
}

extension Float {
    func rounded(toPlaces places: Int) -> Float {
        let multiplier = pow(10, Float(places))
        return (self * multiplier).rounded() / multiplier
    }
}
