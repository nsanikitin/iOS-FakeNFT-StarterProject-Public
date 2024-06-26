//
//  PaymentOptionsViewController.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 23.06.2024.
//

import UIKit

final class PaymentOptionsViewController: UIViewController, PaymentOptionsView {
    
    private var presenter: PaymentOptionsPresenter!
    private var paymentOptions: [PaymentOption] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupUI()
        setupConstraints()
        
        presenter = PaymentOptionsPresenter(view: self)
        presenter.loadPaymentOptions()
    }
    
    @objc private func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupNavigationBar() {
        title = "Выберите способ оплаты"
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(dismissController)
        )
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PaymentOptionCell.self, forCellWithReuseIdentifier: PaymentOptionCell.identifier)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func showPaymentOptions(_ options: [PaymentOption]) {
        paymentOptions = options
        collectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle payment option selection
    }
}
