import UIKit

protocol PaymentOptionsView: AnyObject {
    func showPaymentOptions(_ options: [CurrencyModel])
    func showLoading()
    func hideLoading()
    func updateItemImage(at index: Int, with image: UIImage)
}

final class PaymentOptionsPresenter {
    private weak var view: PaymentOptionsView?
    private var paymentOptions: [CurrencyModel] = []
    private let currentServiceCart: ServiceCart
    
    init(view: PaymentOptionsView, currentServiceCart: ServiceCart) {
        self.view = view
        self.currentServiceCart = currentServiceCart
    }
    
    func loadPaymentOptions() {
        view?.showLoading()
        currentServiceCart.loadCurrencies { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success(let currentList):
                    self?.paymentOptions = Array(currentList)
                    self?.view?.showPaymentOptions(self?.paymentOptions ?? [])
                    self?.loadImages()
                case .failure(let error):
                    print("Ошибка загрузки списка валют: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadImages() {
        for (index, option) in paymentOptions.enumerated() {
            loadImage(from: option.image) { [weak self] image in
                DispatchQueue.main.async {
                    self?.view?.updateItemImage(at: index, with: image!)
                }
            }
        }
    }
    
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
        task.resume()
    }
}
