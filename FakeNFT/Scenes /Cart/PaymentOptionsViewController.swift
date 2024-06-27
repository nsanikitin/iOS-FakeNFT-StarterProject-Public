//
//  PaymentOptionsViewController.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 23.06.2024.
//

import UIKit
import ProgressHUD

final class PaymentOptionsViewController: UIViewController, PaymentOptionsView {
    private var presenter: PaymentOptionsPresenter!
    private var paymentOptions: [CurrencyModel] = []
    private var isLoading = false
    
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
        button.addTarget(self, action: #selector(Pay), for: .touchUpInside)
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
    
    @objc private func Pay() {
        //        let paymentOptionsVC = PaymentOptionsViewController()
        //        let navController = UINavigationController(rootViewController: paymentOptionsVC)
        //        navController.modalPresentationStyle = .fullScreen
        //        present(navController, animated: true, completion: nil)
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
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let numberOfColumns: CGFloat = 2
        let totalSpacing = layout.sectionInset.left + layout.sectionInset.right + (layout.minimumInteritemSpacing * (numberOfColumns - 1))
        let width = (collectionView.bounds.width - totalSpacing) / numberOfColumns
        return CGSize(width: width, height: 48)
    }
}
