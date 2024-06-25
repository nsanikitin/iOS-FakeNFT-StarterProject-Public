//
//  UITextField.swift
//  FakeNFT
//
//  Created by Anna on 24.06.2024.
//

import UIKit

class PaddedTextField: UITextField {
    var padding: UIEdgeInsets
    
    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

//class PaddedTextView: UITextView {
//    override var textContainerInset: UIEdgeInsets {
//        get {
//            return super.textContainerInset
//        }
//        set {
//            super.textContainerInset = newValue
//        }
//    }
//}
