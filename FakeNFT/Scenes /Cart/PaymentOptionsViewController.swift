//
//  PaymentOptionsViewController.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 23.06.2024.
//

import UIKit
import ProgressHUD

final class PaymentOptionsViewController: UIViewController, PaymentOptionsView, PaymentSuccessViewControllerDelegate {
    
    private var presenter: PaymentOptionsPresenter!
    private var paymentOptions: [CurrencyModel] = []
    private var isLoading = false
    private var selectedCurrencyId: String?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 7
        layout.minimumLineSpacing = 7
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let labelAgreemant: UILabel = {
        let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.font = .caption2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hyperlinkLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "Пользовательского соглашения")
        attributedString.addAttribute(.underlineStyle, value: [], range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        label.textColor = .ypBlueUniversal
        label.font = .caption2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оплатить", for: .normal)
        button.backgroundColor = UIColor(named: "ypBlack")
        button.titleLabel?.font = .bodyBold
        button.setTitleColor(UIColor(named: "ypWhite"), for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(pay), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupUI()
        setupConstraints()
        showLoading()
        let networkClient = NetworkClientCart()
        presenter = PaymentOptionsPresenter(view: self, currentServiceCart: ServiceCart(networkClient: networkClient))
        presenter.loadPaymentOptions()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapHyperlinkLabel))
        hyperlinkLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setupNavigationBar() {
        title = "Выберите способ оплаты"
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(dismissController)
        )
        backButton.tintColor = UIColor(named: "ypBlack")
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PaymentOptionCell.self, forCellWithReuseIdentifier: PaymentOptionCell.identifier)
        view.addSubview(collectionView)
        view.addSubview(bottomView)
        bottomView.addSubview(labelAgreemant)
        bottomView.addSubview(hyperlinkLabel)
        bottomView.addSubview(payButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            bottomView.heightAnchor.constraint(equalToConstant: 186),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            labelAgreemant.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            labelAgreemant.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            
            hyperlinkLabel.leadingAnchor.constraint(equalTo: labelAgreemant.leadingAnchor),
            hyperlinkLabel.topAnchor.constraint(equalTo: labelAgreemant.bottomAnchor, constant: 4),
            
            payButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -12),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func showPaymentOptions(_ options: [CurrencyModel]) {
        paymentOptions = options
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoading {
            ProgressHUD.show("Loading...")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isLoading {
            ProgressHUD.dismiss()
        }
    }
    
    func showLoading() {
        isLoading = true
        ProgressHUD.show("Loading...")
    }
    
    func hideLoading() {
        isLoading = false
        ProgressHUD.dismiss()
    }
    
    func updateItemImage(at index: Int, with image: UIImage) {
        if index < paymentOptions.count {
            let indexPath = IndexPath(item: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? PaymentOptionCell {
                cell.updateImage(image)
            }
        }
    }
    
    @objc private func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapHyperlinkLabel() {
        let webViewController = WebViewAgreementController(urlString: "https://yandex.ru/legal/practicum_termsofuse/")
        present(webViewController, animated: true, completion: nil)
    }
    
    @objc private func pay() {
        guard let currencyId = selectedCurrencyId else {
            showAlert(message: "Выберите способ оплаты")
            return
        }
        presenter.pay(currencyId: currencyId)
    }
    
    func showError(_ message: String) {
        showRetryAlert(message: message)
    }
    
    func showPaymentSuccess(_ orderId: String) {
        let successVC = PaymentSuccessViewController()
        successVC.delegate = self
        successVC.modalPresentationStyle = .fullScreen
        present(successVC, animated: true, completion: nil)
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Payment", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func showRetryAlert(message: String) {
        let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.pay()
        })
        present(alertController, animated: true, completion: nil)
    }
    
    func didTapReturnToCatalog() {
        if let navigationController = navigationController, let cartVC = navigationController.viewControllers.first(where: { $0 is CartViewController }) as? CartViewController {
            cartVC.presenter.clearCart()
            navigationController.popToViewController(cartVC, animated: true)
        }
    }
}

extension PaymentOptionsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paymentOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentOptionCell.identifier, for: indexPath) as! PaymentOptionCell
        let option = paymentOptions[indexPath.item]
        cell.configure(with: option)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 0, height: 0)
        }
        let numberOfColumns: CGFloat = 2
        let totalSpacing = layout.sectionInset.left + layout.sectionInset.right + (layout.minimumInteritemSpacing * (numberOfColumns - 1))
        let width = (collectionView.bounds.width - totalSpacing) / numberOfColumns
        return CGSize(width: width, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCurrencyId = paymentOptions[indexPath.item].id
    }
    
}
