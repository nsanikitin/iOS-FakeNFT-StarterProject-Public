import UIKit

protocol PaymentOptionsView: AnyObject {
    func showPaymentOptions(_ options: [CurrencyModel])
    func showLoading()
    func hideLoading()
    func updateItemImage(at index: Int, with image: UIImage)
    func showError(_ message: String)
    func showPaymentSuccess(_ orderId: String)
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
                    self?.view?.showError("Ошибка загрузки списка валют: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadImages() {
        for (index, option) in paymentOptions.enumerated() {
            currentServiceCart.loadImage(from: option.image) { [weak self] image in
                DispatchQueue.main.async {
                    if let image = image {
                        self?.view?.updateItemImage(at: index, with: image)
                    }
                }
            }
        }
    }
    
    func pay(currencyId: String) {
            view?.showLoading()
            currentServiceCart.pay(currencyId: currencyId) { [weak self] result in
                DispatchQueue.main.async {
                    self?.view?.hideLoading()
                    switch result {
                    case .success(let response):
                        self?.view?.showPaymentSuccess(response.orderId)
                    case .failure(let error):
                        self?.view?.showError("Не удалось произвести оплату")
                    }
                }
            }
        }
}
