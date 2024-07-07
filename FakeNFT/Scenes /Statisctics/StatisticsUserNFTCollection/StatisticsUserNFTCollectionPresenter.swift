import Foundation

protocol StatisticsUserNFTCollectionPresenterProtocol: AnyObject {
    
    func viewDidLoad(with userNFTs: [String])
    func loadNFTs()
    func getUserNFTs() -> [NFTModel]
    func updateUserNFTs()
    func showError()
}

final class StatisticsUserNFTCollectionPresenter: StatisticsUserNFTCollectionPresenterProtocol {
    
    // MARK: - Properties
    
    private enum StatisticUserNFTCollectionsState {
        case initial
        case loading
        case failed
        case data
    }
    
    private let statisticsService = StatisticsService.shared
    
    weak var view: StatisticsUserNFTCollectionViewController?
    private var userNftIds: [String] = []
    private var nfts: [NFTModel] = []
    private var userNFTs: [NFTModel] = []
    private var state = StatisticUserNFTCollectionsState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Methods
    
    func viewDidLoad(with userNftIds: [String]) {
        self.userNftIds = userNftIds
        state = .loading
    }
    
    func loadNFTs() {
        statisticsService.fetchNFTs() { [weak self] (response: Result<[NFTModel], Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                nfts = body
                state = .data
            case .failure:
                state = .failed
            }
        }
    }
    
    func getUserNFTs() -> [NFTModel] {
        for id in userNftIds {
            userNFTs += nfts.filter { $0.id == id }
        }
        return userNFTs
    }
    
    func updateUserNFTs() {
        view?.updateNFTCollectionView()
    }
    
    func showError() {
        view?.showErrorAlert()
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("Can't move to initial state")
        case .loading:
            view?.showLoadingIndicator()
            loadNFTs()
        case .data:
            view?.hideLoadingIndicator()
            view?.updateNFTCollectionView()
        case .failed:
            view?.hideLoadingIndicator()
            showError()
        }
    }
}
