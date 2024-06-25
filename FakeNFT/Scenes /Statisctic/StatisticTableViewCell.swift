import UIKit

final class StatisticTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var numberOfCell: UInt = 1
    
    private lazy var colorPartImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .ypLightGrey
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        return imageView
    }()
    
    private lazy var rankLabel = {
        let label = UILabel()
        
        label.text = "\(numberOfCell)"
        label.font = UIFont.caption1
        label.textColor = .ypBlackUniversal
        
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        return label
    }()
    
    private lazy var avatarImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage.userPlaceholderImage
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 14
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        return imageView
    }()
    
    private lazy var nameLabel = {
        let label = UILabel()
        
        label.font = UIFont.headline3
        label.textColor = .ypBlackUniversal
        
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        return label
    }()
    
    private lazy var nftQuantityLabel = {
        let label = UILabel()
        
        label.font = UIFont.headline3
        label.textColor = .ypBlackUniversal
        
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 26, left: 16, bottom: 26, right: 16)
        
        layer.masksToBounds = true
        layer.cornerRadius = 12
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            rankLabel.widthAnchor.constraint(equalToConstant: 27),
            rankLabel.heightAnchor.constraint(equalToConstant: 20),
            rankLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            rankLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 28),
            
            colorPartImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            colorPartImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            colorPartImageView.topAnchor.constraint(equalTo: self.topAnchor),
            colorPartImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            avatarImageView.heightAnchor.constraint(equalToConstant: 28),
            avatarImageView.leadingAnchor.constraint(equalTo: colorPartImageView.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: colorPartImageView.topAnchor, constant: 28),
            
            nftQuantityLabel.widthAnchor.constraint(equalToConstant: 38),
            nftQuantityLabel.heightAnchor.constraint(equalToConstant: 28),
            nftQuantityLabel.trailingAnchor.constraint(equalTo: colorPartImageView.trailingAnchor, constant: -16),
            nftQuantityLabel.topAnchor.constraint(equalTo: colorPartImageView.topAnchor, constant: 28),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: nftQuantityLabel.leadingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: colorPartImageView.topAnchor, constant: 26),
            nameLabel.bottomAnchor.constraint(equalTo: colorPartImageView.bottomAnchor, constant: -26)
        ])
    }
    
    func configure() {
        
    }
}
