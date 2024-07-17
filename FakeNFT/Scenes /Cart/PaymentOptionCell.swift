//
//  PaymentOptionCell.swift
//  FakeNFT
//
//  Created by Рамиль Аглямов on 27.06.2024.
//

import UIKit

final class PaymentOptionCell: UICollectionViewCell {
    
    static let identifier = "PaymentOptionCell"
    
    private let сontainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = UIColor(named: "ypBlack")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .caption2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .caption2
        label.textColor = .ypGreenUniversal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(сontainerView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(codeLabel)
        setupCellAppearance()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            сontainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            сontainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            сontainerView.widthAnchor.constraint(equalToConstant: 36),
            сontainerView.heightAnchor.constraint(equalToConstant: 36),
            
            iconImageView.centerXAnchor.constraint(equalTo: сontainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: сontainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: сontainerView.widthAnchor, multiplier: 0.8),
            iconImageView.heightAnchor.constraint(equalTo: сontainerView.heightAnchor, multiplier: 0.8),
            
            nameLabel.topAnchor.constraint(equalTo: сontainerView.topAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: сontainerView.trailingAnchor, constant: 6),
            
            codeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1),
            codeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }
    
    private func setupCellAppearance() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .ypLightGrey
        updateBorderColor()
        contentView.layer.borderWidth = 0.0
    }
    
    private func updateBorderColor() {
        contentView.layer.borderColor = UIColor(named: "ypBlack")?.cgColor
    }
    
    func configure(with option: CurrencyModel) {
        //        iconImageView.image = option.image
        nameLabel.text = option.title
        codeLabel.text = option.name
        iconImageView.image = nil
    }
    
    func updateImage(_ image: UIImage?) {
        iconImageView.image = image
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.layer.borderWidth = 1.0
            } else {
                contentView.layer.borderWidth = 0.0
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection) == true {
            updateBorderColor()
        }
    }
}
