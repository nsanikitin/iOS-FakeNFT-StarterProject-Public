//
//  Utils.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 18.06.2024.
//

import UIKit

extension UIColor {
    static var invertedSystemBackground: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return .white
            } else {
                return .black
            }
        }
    }
}
