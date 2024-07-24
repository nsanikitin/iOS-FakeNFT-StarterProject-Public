//
//  DeveloperInfoViewController.swift
//  FakeNFT
//
//  Created by Anna on 21.06.2024.
//

import UIKit
import WebKit

final class DeveloperInfoViewController: UIViewController {
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadDeveloperInfo()
        setupNavigationItem()
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func loadDeveloperInfo() {
        if let url = URL(string: "https://practicum.yandex.ru/ios-developer") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func setupWebView() {
        webView = WKWebView(frame: self.view.frame)
        self.view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupNavigationItem() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .ypWhite
        let backButton = UIBarButtonItem(
            image: UIImage.backwardImage,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = backButton
    }
}
