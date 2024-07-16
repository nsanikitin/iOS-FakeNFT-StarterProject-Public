//
//  UIImageView+Extensions.swift
//  FakeNFT
//
//  Created by Anna on 01.07.2024.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage?) {
        self.image = placeholder
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
