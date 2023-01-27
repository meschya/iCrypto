import Foundation

protocol HomeViewProtocol: AnyObject {
    func success()
}

protocol HomeViewPresenterProtocol: AnyObject {
    init(view: HomeViewProtocol, networkManager: NetworkManagerProtocol)
    var coins: [CoinModel]? { get set }
    
    var refreshTable: (() -> Void)? { get set }
    func refresh()
    func fetchCoins()
}

final class HomePresenter: HomeViewPresenterProtocol {
    // MARK: - Properties
    
    weak var view: HomeViewProtocol?
    var networkManager: NetworkManagerProtocol?
    var coins: [CoinModel]?
    var refreshTable: (() -> Void)?
    
    // MARK: - Initialisation
    
    init(view: HomeViewProtocol, networkManager: NetworkManagerProtocol) {
        self.view = view
        self.networkManager = networkManager
    }
    
    func refresh() {
        NetworkManager.instance.getCoins { [weak self] result in
            self?.coins = result
            self?.view?.success()
            self?.refreshTable?()
        }
    }
    
    func fetchCoins() {
        NetworkManager.instance.getCoins { [weak self] result in
            self?.coins = result
            self?.view?.success()
        }
    }
}
