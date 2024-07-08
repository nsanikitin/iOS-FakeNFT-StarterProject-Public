import Kingfisher
import UIKit

final class StatisticsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var isLiked = false
    private var isInCart = false
    
    private lazy var nftPictureImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var likeButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var nftRatingImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var nftNameLabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = .ypBlackUniversal
        return label
    }()
    
    private lazy var nftCostLabel = {
        let label = UILabel()
        label.font = UIFont.caption3
        label.textColor = .ypBlackUniversal
        return label
    }()
    
    private lazy var cartButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(cartButtonDidTap), for: .touchUpInside)
        button.backgroundColor = .clear
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(for nft: NFTModel) {
        nftPictureImageView.kf.setImage(with: URL(string: nft.images[0]))
        nftRatingImageView.image = UIImage(named: "stars\(nft.rating)")
        nftNameLabel.text = nft.name
        nftCostLabel.text = "\(nft.price) ETH"
        likeButton.setImage(UIImage.likesNoActiveImage, for: .normal)
        cartButton.setImage(UIImage.cartEmptyImage, for: .normal)
    }
    
    // MARK: - View Configuration
    
    private func setupConstraints() {
        [nftPictureImageView, likeButton, nftRatingImageView, nftNameLabel, nftCostLabel, cartButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            nftPictureImageView.topAnchor.constraint(equalTo: topAnchor),
            nftPictureImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftPictureImageView.heightAnchor.constraint(equalToConstant: 108),
            nftPictureImageView.widthAnchor.constraint(equalToConstant: 108),
            
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.topAnchor.constraint(equalTo: nftPictureImageView.topAnchor, constant: -1),
            likeButton.trailingAnchor.constraint(equalTo: nftPictureImageView.trailingAnchor, constant: 1),
            
            nftRatingImageView.heightAnchor.constraint(equalToConstant: 12),
            nftRatingImageView.topAnchor.constraint(equalTo: nftPictureImageView.bottomAnchor, constant: 8),
            nftRatingImageView.leadingAnchor.constraint(equalTo: nftPictureImageView.leadingAnchor),
            nftRatingImageView.trailingAnchor.constraint(equalTo: nftPictureImageView.trailingAnchor, constant: -40),

            nftNameLabel.heightAnchor.constraint(equalToConstant: 22),
            nftNameLabel.topAnchor.constraint(equalTo: nftRatingImageView.bottomAnchor, constant: 5),
            nftNameLabel.leadingAnchor.constraint(equalTo: nftRatingImageView.leadingAnchor),
            nftNameLabel.trailingAnchor.constraint(equalTo: nftRatingImageView.trailingAnchor),
            
            nftCostLabel.heightAnchor.constraint(equalToConstant: 12),
            nftCostLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            nftCostLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            nftCostLabel.trailingAnchor.constraint(equalTo: nftNameLabel.trailingAnchor),

            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.topAnchor.constraint(equalTo: nftNameLabel.topAnchor),
            cartButton.trailingAnchor.constraint(equalTo: nftPictureImageView.trailingAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func likeButtonDidTap() {
        let image: UIImage = isLiked ? .likesNoActiveImage : .likesActiveImage
        likeButton.setImage(image, for: .normal)
        isLiked.toggle()
    }

    @objc
    private func cartButtonDidTap() {
        let image: UIImage = isInCart ? .cartEmptyImage : .cartDeleteImage
        cartButton.setImage(image, for: .normal)
        isInCart.toggle()
    }
}
