import UIKit
import ProgressHUD

final class CartViewController: UIViewController, CartView {
    private var presenter: CartPresenter!
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "sortIcon"), style: .plain, target: self, action: #selector(sortItems))
        button.tintColor = .black
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let totalCountLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .ypGreenUniversal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("К оплате", for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = .bodyBold
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emptyCartLabel: UILabel = {
            let label = UILabel()
            label.text = "Корзина пуста"
            label.textAlignment = .center
            label.font = .bodyBold
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isHidden = true
            return label
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let networkClientCart = NetworkClientCart()
        let nftServiceCart = NFTServiceCart(networkClient: networkClientCart)
        presenter = CartPresenter(view: self, nftServiceCart: nftServiceCart)
        setupNavigationBar()
        setupBottomView()
        setupTableView()
        setupEmptyCartLabel()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartCell.self, forCellReuseIdentifier: "CartCell")
        view.addSubview(tableView)
    }
    
    private func setupBottomView() {
        bottomView.addSubview(totalCountLabel)
        bottomView.addSubview(totalPriceLabel)
        bottomView.addSubview(payButton)
        view.addSubview(bottomView)
    }
    
    private func setupEmptyCartLabel() {
            view.addSubview(emptyCartLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.heightAnchor.constraint(equalToConstant: 76),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            totalCountLabel.topAnchor.constraint(equalTo: payButton.topAnchor),
            totalCountLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            
            totalPriceLabel.topAnchor.constraint(equalTo: totalCountLabel.bottomAnchor, constant: 2),
            totalPriceLabel.leadingAnchor.constraint(equalTo: totalCountLabel.leadingAnchor),
            
            payButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            payButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            payButton.widthAnchor.constraint(equalToConstant: 240),
            payButton.heightAnchor.constraint(equalToConstant: 44),
            
            emptyCartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
             
        ])
    }
    
    @objc private func sortItems() {
        presenter.sortItems()
    }
    
    func updateTotalPrice(totalCount: Int, totalPrice: Float) {
        totalCountLabel.text = "\(totalCount) NFT"
        totalPriceLabel.text = "\(totalPrice) ETH"
        emptyCartLabel.isHidden = totalCount > 0
        bottomView.isHidden = totalCount == 0
    }
    
    func reloadData() {
        tableView.reloadData()
        emptyCartLabel.isHidden = presenter.numberOfItems() > 0
        bottomView.isHidden = presenter.numberOfItems() == 0
    }
    
    func showLoading() {
        ProgressHUD.show("Loading...")
    }
    
    func hideLoading() {
        ProgressHUD.dismiss()
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        let item = presenter.getItem(at: indexPath.row)
        cell.configure(with: item) { [weak self] in
            self?.presenter.deleteItem(at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
