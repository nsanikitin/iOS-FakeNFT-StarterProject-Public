//
//  PaymentOptionsPresenter.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 27.06.2024.
//

import UIKit

protocol PaymentOptionsView: AnyObject {
    func showPaymentOptions(_ options: [PaymentOption])
}

final class PaymentOptionsPresenter {
    private weak var view: PaymentOptionsView?
    private var paymentOptions: [PaymentOption] = []
    
    init(view: PaymentOptionsView) {
        self.view = view
    }
    
    func loadPaymentOptions() {
        // Simulate loading data from a network or database
        paymentOptions = [
            PaymentOption(name: "Bitcoin", code: "BTC", icon: UIImage(named: "criptoBTC")!),
            PaymentOption(name: "Dogecoin", code: "DOGE", icon: UIImage(named: "criptoDOGE")!),
            PaymentOption(name: "Dogecoin", code: "DOGE", icon: UIImage(named: "criptoDOGE")!),
            PaymentOption(name: "Dogecoin", code: "DOGE", icon: UIImage(named: "criptoDOGE")!)
            // Add other payment options here
        ]
        
        view?.showPaymentOptions(paymentOptions)
    }
}
