import UIKit

protocol PaymentOptionsView: AnyObject {
    func showPaymentOptions(_ options: [CurrencyModel])
    func showLoading()
    func hideLoading()
    func updateItemImage(at index: Int, with image: UIImage)
    func showError(_ alertController: UIAlertController)
    func showPaymentSuccess(_ orderId: String)
}

final class PaymentOptionsPresenter {
    private weak var view: PaymentOptionsView?
    private var paymentOptions: [CurrencyModel] = []
    private let currentServiceCart: ServiceCart
    private var selectedCurrencyId: String?
    
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
                    self?.view?.showError(self?.createErrorAlert(message: "Ошибка загрузки списка валют: \(error.localizedDescription)") ?? UIAlertController())
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
    
    func selectCurrencyId(_ currencyId: String) {
        self.selectedCurrencyId = currencyId
    }
    
    func pay() {
        guard let currencyId = selectedCurrencyId else {
            view?.showError(createErrorAlert(message: "Выберите способ оплаты"))
            return
        }
        
        view?.showLoading()
        currentServiceCart.pay(currencyId: currencyId) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success(let response):
                    self?.view?.showPaymentSuccess(response.orderId)
                case .failure(let error):
                    self?.view?.showError(self?.createErrorAlert(message: "Не удалось произвести оплату") ?? UIAlertController())
                }
            }
        }
    }
    
    private func createErrorAlert(message: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertController
    }
    
    private func createRetryAlert(message: String, retryHandler: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
            retryHandler()
        })
        return alertController
    }
}
