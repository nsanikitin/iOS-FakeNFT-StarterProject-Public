//
//  WebViewViewController.swift
//  FakeNFT
//
//  Created by Тася Галкина on 09.07.2024.
//

import Foundation
import WebKit
import UIKit

final class WebViewController: UIViewController {
    
    private var urlName: URL
    let backButton = UIButton()
    let webView = WKWebView()
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        configureBackButton()
        configureWebView()
        configureLoadingIndicator()
        
        loadURL()
    }
    
    private func configureBackButton() {
        view.addSubview(backButton)
        
        backButton.setImage(UIImage(named: "backward")?.withTintColor(.ypBlack), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configureWebView() {
        view.addSubview(webView)
        
        webView.navigationDelegate = self
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 9),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureLoadingIndicator() {
        view.addSubview(loadingIndicator)
        
        loadingIndicator.hidesWhenStopped = true
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    init(urlName: URL) {
        self.urlName = urlName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadURL() {
        let request = URLRequest(url: urlName)
        webView.load(request)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
    }
}
