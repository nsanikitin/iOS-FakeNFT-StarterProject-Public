//
//  ProfileTableViewCell.swift
//  FakeNFT
//
//  Created by Anna on 21.06.2024.
//

import UIKit

final class ProfileTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ProfileTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = .ypBlack
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage.chevronRight
        image.tintColor = .ypBlack
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [titleLabel, chevronImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),

            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 10),
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func updateTitle(text: String) {
        titleLabel.text = text
    }
}
