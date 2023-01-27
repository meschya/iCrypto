import Foundation
import UIKit
import CoreData

protocol MainViewProtocol: AnyObject {
    func success()
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, networkManager: NetworkManagerProtocol)
    
    var coins: [CoinModel]? { get set }
    var wallets: [Wallet]? { get set }
    
    func fetchCoins()
}

final class MainPresenter: MainViewPresenterProtocol {
    // MARK: - Properties
    
    weak var view: MainViewProtocol?
    var networkManager: NetworkManagerProtocol?
    var coins: [CoinModel]?
    var wallets: [Wallet]?
    
    // MARK: - Initialisation
    
    init(view: MainViewProtocol, networkManager: NetworkManagerProtocol) {
        self.view = view
        self.networkManager = networkManager
    }
    
    func fetchCoins() {
        NetworkManager.instance.getCoins { [weak self] result in
            self?.coins = result
            self?.view?.success()
        }
    }
}
