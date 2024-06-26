import UIKit
import ProgressHUD

final class CartViewController: UIViewController, CartView {
    private var presenter: CartPresenter!
    private var isLoading = false
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage.sortImage, style: .plain, target: self, action: #selector(sortItems))
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
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] 
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
        button.addTarget(self, action: #selector(showPaymentOptions), for: .touchUpInside)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoading {
            ProgressHUD.show("Loading...")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isLoading {
            ProgressHUD.dismiss()
        }
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
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let sortByPriceAction = UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            self?.presenter.sortItems(by: .price)
        }
        
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.presenter.sortItems(by: .rating)
        }
        
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.presenter.sortItems(by: .name)
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alertController.addAction(sortByPriceAction)
        alertController.addAction(sortByRatingAction)
        alertController.addAction(sortByNameAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func showPaymentOptions() {
        let paymentOptionsVC = PaymentOptionsViewController()
        let navController = UINavigationController(rootViewController: paymentOptionsVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
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
        isLoading = true
        ProgressHUD.show("Loading...")
    }
    
    func hideLoading() {
        isLoading = false
        ProgressHUD.dismiss()
    }
    
    private func showDeleteConfirmation(for item: NFTModel, at index: Int) {
        let deleteVC = DeleteConfirmationViewController()
        deleteVC.modalPresentationStyle = .overFullScreen
        deleteVC.modalTransitionStyle = .crossDissolve
        deleteVC.configure(with: UIImage(named: item.name)) // Assuming the image name is same as the item name
        deleteVC.confirmHandler = { [weak self] in
            self?.presenter.deleteItem(at: index)
        }
        present(deleteVC, animated: true, completion: nil)
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
            self?.showDeleteConfirmation(for: item, at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
