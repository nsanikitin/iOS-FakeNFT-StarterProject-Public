import Foundation

class CartPresenter {
    weak var view: CartView?
    private var items: [NFTModel] = []
    private let nftServiceCart: NFTServiceCart
    
    init(view: CartView, nftServiceCart: NFTServiceCart) {
        self.view = view
        self.nftServiceCart = nftServiceCart
        loadItems()
    }

    var totalPrice: Float {
        return items.reduce(0) { $0 + $1.price }
    }

    func loadItems() {
        view?.showLoading()
        nftServiceCart.loadNFTs { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()  
                switch result {
                case .success(let nftList):
                    self?.items = Array(nftList.prefix(3))
                    self?.view?.updateTotalPrice(totalCount: self?.items.count ?? 0, totalPrice: self?.totalPrice ?? 0)
                    self?.view?.reloadData()
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

    func sortItems() {
        items.sort { $0.name < $1.name }
        view?.reloadData()
    }
}
